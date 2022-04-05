// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:docs/src/model/page.dart';
import 'package:docs/src/model/story.dart';

/// The document resources
final List<Story> documentResources = [
  Story(title: '1 - Getting Started', pages: [
    Page(title: 'Introduction', resourcePath: 'assets/00_introduction.md'),
    Page(title: 'Fundamentals', resourcePath: 'assets/01_fundamentals.md')
  ])
];
