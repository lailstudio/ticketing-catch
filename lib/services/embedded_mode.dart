// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

bool get isEmbeddedMode {
  return html.document.getElementById('seo-header') != null;
}
