import 'dart:async';

// Tracks the app's "is the network usable" signal. M1 is a skeleton: the real
// connectivity probe gets wired at M2 (DAV) and M6 (mail IDLE). The interface
// is intentionally minimal so the sync engine can be tested against a fake.
enum ConnectionState { online, offline, throttled }

class ConnectionManager {
  ConnectionManager({ConnectionState initial = ConnectionState.online})
    : _state = initial;

  ConnectionState _state;
  final StreamController<ConnectionState> _events =
      StreamController<ConnectionState>.broadcast();

  ConnectionState get state => _state;
  Stream<ConnectionState> get changes => _events.stream;

  void set(ConnectionState next) {
    if (next == _state) {
      return;
    }
    _state = next;
    _events.add(next);
  }

  Future<void> dispose() => _events.close();
}
