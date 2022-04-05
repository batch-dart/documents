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
          child: Card(
            elevation: 5,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: rootBundle.loadString(resource),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        return Column(
                          children: _markdownLines(context, snapshot.data),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                      child: Text(
                        'The content on this page is licensed under the CC BY 4.0 License, and code samples under the BSD-3 License.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  List<Widget> _markdownLines(
    final BuildContext context,
    final String resource,
  ) {
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
                p: const TextStyle(fontSize: 16),
                h1: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                h2: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                h3: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                h4: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                h1Padding: const EdgeInsets.all(10),
                h2Padding: const EdgeInsets.all(10),
                h3Padding: const EdgeInsets.all(10),
                h4Padding: const EdgeInsets.all(10),
                blockquotePadding: const EdgeInsets.all(20),
                blockSpacing: 20,
                blockquoteDecoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[600],
                  borderRadius: BorderRadius.circular(2.0),
                ),
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
