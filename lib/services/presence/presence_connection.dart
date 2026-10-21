abstract class PresenceConnection {
  Future<void> get ready;
  Stream<String> get messages;
  bool get visible;
  Stream<bool> get visibility;
  Stream<void> get interactions;
  void send(String data);
  void close();
}
