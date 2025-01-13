import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebService {
  static final _instance = ChatWebService._internal();

  factory ChatWebService() => _instance;
  WebSocketChannel? _socket;
  StreamSubscription? _socketSub;

  final StreamController<Map<String, dynamic>> _contentController =
      StreamController<Map<String, dynamic>>();
  final StreamController<Map<String, dynamic>> _searchController =
      StreamController<Map<String, dynamic>>();

  final StreamController<Map<String, dynamic>> _imagesController =
      StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get imageStream => _imagesController.stream;
  Stream<Map<String, dynamic>> get searchStream => _searchController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;

  ChatWebService._internal();
  void connect() async {
    disconnect(); // Close the existing socket and controllers before reconnecting
    _socket =
        WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws/chat"));

    try {
      _socketSub = _socket!.stream.listen((message) {
        var data = json.decode(message);
        if (data["type"] == "search_results") {
          _searchController.add(data);
        } else if (data["type"] == "content") {
          _contentController.add(data);
        } else if (data["type"] == "images") {
          _imagesController.add(data);
        }
      });
    } catch (e) {
      print("Socket exception: " + e.toString());
    }
  }

  void send(String query) {
    _socket!.sink.add(json.encode({"query": query}));
  }

  void disconnect() {
    print("Disconnecting from streams and socket");
    _socketSub?.cancel();
    _socketSub = null; // Reset to prevent reuse of the canceled subscription
    _socket?.sink.close(); // Properly close the WebSocket connection
    _socket = null;
  }
}
