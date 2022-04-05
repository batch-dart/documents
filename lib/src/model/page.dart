// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

class Page {
  /// Returns the new instance of [Page].
  Page({
    required this.title,
    required this.resourcePath,
  });

  /// The title
  final String title;

  /// The resource path
  final String resourcePath;
}
