export 'presence_wire_stub.dart'
    if (dart.library.io) 'presence_wire_native.dart'
    if (dart.library.js_interop) 'presence_wire_web.dart';
