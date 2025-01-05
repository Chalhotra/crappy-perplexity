import 'package:flutter/material.dart';

class SourceCard extends StatelessWidget {
  final String title;
  final String url;
  final String content;
  const SourceCard(
      {super.key,
      required this.title,
      required this.url,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Wrap(
          direction: Axis.vertical,
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
            Text(
              content,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
