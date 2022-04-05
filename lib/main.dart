// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:dashbook/dashbook.dart';
import 'package:docs/src/document_resources.dart';
import 'package:docs/src/view/markdown_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final dashbook = Dashbook.dualTheme(
    title: 'Documents',
    light: ThemeData(
      brightness: Brightness.light,
      typography: Typography.material2018(),
      textTheme: GoogleFonts.oxygenTextTheme(Typography.blackMountainView),
    ),
    dark: ThemeData(
      brightness: Brightness.dark,
      typography: Typography.material2018(),
      textTheme: GoogleFonts.oxygenTextTheme(Typography.whiteMountainView),
    ),
    initWithLight: true,
  );

  _addGettingStarted(dashbook);

  runApp(dashbook);
}

void _addGettingStarted(Dashbook dashbook) {
  for (final resource in documentResources) {
    final story = dashbook.storiesOf(resource.title);

    for (final page in resource.pages) {
      story.add(
        page.title,
        (context) => MarkdownView(
          title: page.title,
          resource: page.resourcePath,
        ),
      );
    }
  }
}
