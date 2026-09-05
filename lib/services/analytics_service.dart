import 'dart:js_interop';

import 'package:flutter/material.dart';

@JS('sendPageView')
external void _jsSendPageView(JSString pagePath);

class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _trackRoute(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _trackRoute(previousRoute);
  }

  void _trackRoute(Route<dynamic> route) {
    final pagePath = route.settings.name ?? '/';
    _jsSendPageView(pagePath.toJS);
  }
}
