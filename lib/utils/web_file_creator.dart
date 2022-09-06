// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

void downloadFile(String content, String filename) {
  if (!kIsWeb) {
    throw Exception("NEVER RUN THIS CODE IN NON-WEB PLATFORM.");
  }

  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = filename;
  html.document.body?.children.add(anchor);

// download
  anchor.click();

// cleanup
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
