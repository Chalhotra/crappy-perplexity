import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'source_card.dart';
import 'web_sockets.dart';

class ResultsPage extends StatefulWidget {
  final String query;
  const ResultsPage({required this.query, Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Image> images = [];
  StreamSubscription? _contentSub;
  StreamSubscription? _imageSub;
  String content = "";

  @override
  void initState() {
    super.initState();
    _subscribeToStreams();
  }

  void _subscribeToStreams() {
    // Cancel existing subscriptions before creating new ones
    _cancelSubscriptions();

    try {
      _contentSub = ChatWebService().contentStream.listen(
        (data) {
          try {
            if (mounted) {
              setState(() {
                content += data["data"];
              });
            }
          } catch (e, stackTrace) {
            debugPrint("Error processing content stream data: $e\n$stackTrace");
          }
        },
        onError: (error) {
          debugPrint("Error in content stream subscription: $error");
        },
        onDone: () {
          debugPrint("Content stream subscription closed");
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Error subscribing to contentStream: $e\n$stackTrace");
    }

    try {
      _imageSub = ChatWebService().imageStream.listen(
        (data) {
          try {
            if (mounted) {
              setState(() {
                images.add(Image.network(data['data']));
              });
            }
          } catch (e, stackTrace) {
            debugPrint("Error processing image stream data: $e\n$stackTrace");
          }
        },
        onError: (error) {
          debugPrint("Error in image stream subscription: $error");
        },
        onDone: () {
          debugPrint("Image stream subscription closed");
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Error subscribing to imageStream: $e\n$stackTrace");
    }
  }

  void _cancelSubscriptions() {
    _contentSub?.cancel();
    _contentSub = null;
    _imageSub?.cancel();
    _imageSub = null;
  }

  @override
  void dispose() {
    _cancelSubscriptions(); // Properly cancel subscriptions
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Results")),
        body: Center(
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Markdown(
                        data: content,
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Wrap(
                    children: images,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
