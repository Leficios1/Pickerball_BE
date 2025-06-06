import 'package:flutter/material.dart';

class LimitedTextWidget extends StatelessWidget {
  final int? maxLines;
  final String? title;
  final String content;
  final TextStyle? style;

  const LimitedTextWidget({
    super.key,
    this.maxLines,
    this.title,
    required this.content,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title != null ? '$title$content' : content,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: style,
    );
  }
}
