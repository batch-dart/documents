// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:docs/src/model/page.dart';

class Story {
  /// Returns the new instance of [Story].
  Story({
    required this.title,
    required this.pages,
  });

  /// The title
  final String title;

  /// The page
  final List<Page> pages;
}
