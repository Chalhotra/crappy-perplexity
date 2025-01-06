import 'package:flutter/material.dart';

class SourceCard extends StatelessWidget {
  final String title;
  final String url;
  const SourceCard({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            url,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
