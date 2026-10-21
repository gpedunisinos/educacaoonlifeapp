import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/presence/presence_connection.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';

class TestWire implements PresenceConnection {
  final input=StreamController<String>();
  final changes=StreamController<bool>.broadcast();
  final actions=StreamController<void>.broadcast();
  final sent=<Map<String,dynamic>>[];
  bool closed=false;
  @override bool visible=true;
  @override Future<void> get ready async {}
  @override Stream<String> get messages=>input.stream;
  @override Stream<bool> get visibility=>changes.stream;
  @override Stream<void> get interactions=>actions.stream;
  @override void send(String data)=>sent.add(jsonDecode(data));
  @override void close(){closed=true;input.close();changes.close();actions.close();}
  void frame(Map<String,dynamic> data)=>input.add(jsonEncode(data));
}
const user=AuthUser(id:1,name:'Pessoa Teste',email:'synthetic@example.test',token:'private-fixture-token',usageMode:'explorer');
Map<String,dynamic> person(String id,String destination)=>{'id':id,'name':'Bruna','destination':destination,'activity':'Explorando pistas'};
void main(){
  test('section mapping shares generic sections only and ignores record IDs',(){
    for(final route in ['/living_clues/42','/space/research/42','/living_clues/update?id=42']) {expect(presenceSection(route),'research');}
    expect(presenceSection('/living_clues/map'),'earth');
    expect(presenceSection('/nodes/graph?focus=42'),'observatory');
    expect(presenceSection('/space/agents/7'),'agents');
    expect(presenceSection('/management'),'platform');
    expect(presenceSection('/space'),'cockpit');
  });
  testWidgets('auth stays in transport, updates are versioned and logout clears identity',(tester) async {
    final wire=TestWire();final service=PresenceService(connect:(_)=>wire,endpoint:Uri.parse('ws://127.0.0.1/api/presence'),supported:true);
    service.route('/living_clues/42');service.setAccount(user);await tester.pump();
    expect(wire.sent.first,{'type':'auth','token':user.token});expect(service.available.value,false);
    wire.frame({'type':'snapshot','version':1,'self':'local','participants':[person('local','research'),person('remote','earth')]});await tester.pump();
    expect(service.available.value,true);expect(service.participants.length,2);
    expect(wire.sent.last['destination'],'research');
    expect(jsonEncode(service.sceneState),isNot(contains(user.token)));
    wire.frame({'type':'update','version':2,'participants':[person('remote','agents')],'removed':[]});await tester.pump();
    expect(service.participants.last.destination,'agents');
    wire.frame({'type':'update','version':1,'participants':[person('remote','earth')]});await tester.pump();
    expect(service.participants.last.destination,'agents');
    service.route('/management');expect(wire.sent.last['destination'],'platform');
    wire.visible=false;wire.changes.add(false);await tester.pump();expect(wire.sent.last['visible'],false);
    await tester.pump(const Duration(seconds:20));expect(wire.sent.last['type'],'heartbeat');expect(wire.sent.last['interacted'],false);
    service.setAccount(null);expect(wire.sent.last['type'],'bye');expect(wire.closed,true);expect(service.participants,isEmpty);expect(service.self,'');service.onClose();
  });
  testWidgets('network failure preserves section, reconnects once and never presents stale count as current',(tester) async {
    final sockets=<TestWire>[];
    final service=PresenceService(connect:(_){final wire=TestWire();sockets.add(wire);return wire;},endpoint:Uri.parse('ws://127.0.0.1/api/presence'),supported:true);
    service.setAccount(user);await tester.pump();
    sockets.first.frame({'type':'snapshot','version':5,'self':'local','participants':[person('local','earth')]});await tester.pump();
    service.route('/nodes/graph');await sockets.first.input.close();await tester.pump();
    expect(service.available.value,false);expect(service.sceneState['participants'],isEmpty);
    await tester.pump(const Duration(seconds:2));await tester.pump();expect(sockets.length,2);
    sockets.last.frame({'type':'snapshot','version':1,'self':'new-local','participants':[person('new-local','observatory')]});await tester.pump();
    expect(service.available.value,true);expect(sockets.last.sent.last['destination'],'observatory');expect(service.self,'new-local');
    service.onClose();
  });
  testWidgets('unsupported platform never connects and keeps normal navigation',(tester) async {
    final service=PresenceService(connect:(_)=>throw StateError('must not connect'),supported:false);
    service.setAccount(user);service.route('/space');expect(service.available.value,false);service.onClose();
  });
}
