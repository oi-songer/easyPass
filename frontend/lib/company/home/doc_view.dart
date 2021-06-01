import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DocView extends StatelessWidget {
  final markdownContent = "# API文档\n请使用ak,sk进行请求";

  @override
  Widget build(BuildContext context) {
    return Markdown(data: markdownContent);
  }
}
