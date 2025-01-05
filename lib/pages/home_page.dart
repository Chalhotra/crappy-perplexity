import 'dart:convert';

import 'package:dox/pages/source_card.dart';
import 'package:dox/pages/web_sockets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String content = "";
  String sources = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    ChatWebService().connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: ChatWebService().searchStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var data = snapshot.data;
                          List<dynamic> cardDatas = data!["data"];

                          return SingleChildScrollView(
                            child: Row(
                              children: [
                                for (var i in cardDatas)
                                  SourceCard(
                                      title: i['title'] ?? '',
                                      url: i['url'] ?? '',
                                      content: i['content'] ?? '')
                              ],
                            ),
                          );
                        }
                      }),
                  Text(
                    "What do you want to know",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 400,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "problem";
                        } else {
                          return null;
                        }
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ChatWebService().send(searchController.text);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: ChatWebService().contentStream,
                    builder: (context, snapshot) {
                      // Check if snapshot has data and it's not null
                      if (snapshot.hasData && snapshot.data != null) {
                        try {
                          // Decode the JSON data safely
                          Map<String, dynamic> data = snapshot.data!;
                          // Check if content exists within the decoded data
                          content += data["data"];
                          return Text(content);
                        } catch (e) {
                          // Handle any JSON decoding errors gracefully
                          print("Error decoding JSON: $e");
                        }
                      }
                      // Return an empty widget if there's no valid content
                      return Text("");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
