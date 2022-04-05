// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:docs/src/component/code_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class MarkdownView extends StatelessWidget {
  /// Returns the new instance of [MarkdownView].
  const MarkdownView({
    Key? key,
    required this.title,
    required this.resource,
  }) : super(key: key);

  /// The title
  final String title;

  /// The markdown resource
  final String resource;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 50,
            ),
          ),
          elevation: 1,
          toolbarHeight: 120,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[850],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: rootBundle.loadString(resource),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      return Column(children: _markdownLines(snapshot.data));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  List<Widget> _markdownLines(final String resource) {
    final lines = <Widget>[];

    final resources = _removeToc(resource).split('```');
    for (int i = 0; i < resources.length; i++) {
      if (i % 2 == 0) {
        lines.add(
          Align(
            alignment: Alignment.topLeft,
            child: MarkdownBody(
              selectable: true,
              data: resources[i],
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                [
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                ],
              ),
              styleSheet: MarkdownStyleSheet(
                h1Padding: const EdgeInsets.all(10),
                h2Padding: const EdgeInsets.all(10),
                h3Padding: const EdgeInsets.all(10),
                h4Padding: const EdgeInsets.all(10),
              ),
              onTapLink: (text, href, title) async => await launch(href!),
            ),
          ),
        );
      } else {
        lines.add(CodeBlock(value: resources[i]));
      }
    }

    return lines;
  }

  String _removeToc(final String resource) {
    final start = resource.indexOf('<!-- TOC -->');
    final end = resource.indexOf('<!-- /TOC -->');

    return resource.substring(0, start - 1) +
        resource.substring(end + '<!-- /TOC -->'.length);
  }
}
