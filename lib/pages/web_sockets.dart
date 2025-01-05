import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebService {
  static final _instance = ChatWebService._internal();

  factory ChatWebService() => _instance;
  WebSocketChannel? _socket;

  final StreamController<Map<String, dynamic>> _contentController =
      StreamController<Map<String, dynamic>>();
  final StreamController<Map<String, dynamic>> _searchController =
      StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get searchStream => _searchController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;
  ChatWebService._internal();
  void connect() async {
    _socket =
        WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws/chat"));
    await _socket!.ready;

    _socket!.stream.listen((message) {
      print(message);
      var data = json.decode(message);
      if (data["type"] == "search_results") {
        _searchController.add(data);
      } else {
        _contentController.add(data);
      }
    });
  }

  void send(String query) {
    _socket!.sink.add(json.encode({"query": query}));
  }
}
