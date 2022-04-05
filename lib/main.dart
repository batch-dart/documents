// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:dashbook/dashbook.dart';
import 'package:docs/src/view/markdown_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final dashbook = Dashbook.dualTheme(
    title: 'Batch.dart Documentations',
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
    initWithLight: false,
  );

  addGettingStarted(dashbook);
  runApp(dashbook);
}

void addGettingStarted(Dashbook dashbook) {
  dashbook
      .storiesOf('1 - Getting Started')
      .add(
        'Introduction',
        (context) => const MarkdownView(
          title: 'Introduction',
          resource: 'assets/00_introduction.md',
        ),
      )
      .add(
        'Fundamentals',
        (context) => const MarkdownView(
          title: 'Fundamentals',
          resource: 'assets/01_fundamentals.md',
        ),
      );
}
