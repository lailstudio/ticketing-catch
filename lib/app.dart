// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'data/venue_presets.dart';
import 'services/analytics_service.dart';
import 'services/embedded_mode.dart';
import 'screens/charm_gallery_screen.dart';
import 'screens/grape_practice_landing_screen.dart';
import 'screens/home_screen.dart';
import 'screens/practice_landing_screen.dart';
import 'screens/seat_practice_landing_screen.dart';
import 'screens/venue_detail_screen.dart';

class TicketingApp extends StatelessWidget {
  const TicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '티켓팅캐치',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C2D91),
        ),
      ),
      navigatorObservers: [AnalyticsRouteObserver()],
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;

    if (isEmbeddedMode) {
      final currentPath = html.window.location.pathname;
      if (path != currentPath) {
        html.window.location.href = path;
        return MaterialPageRoute(
          builder: (_) => const SizedBox.shrink(),
        );
      }
    }

    if (path == '/ticketing-charm') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CharmGalleryScreen(),
      );
    }

    if (path == '/practice') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const PracticeLandingScreen(),
      );
    }

    if (path == '/seat-practice') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const SeatPracticeLandingScreen(),
      );
    }

    if (path == '/grape-practice') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const GrapePracticeLandingScreen(),
      );
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'venue') {
      final slug = uri.pathSegments[1];
      final preset = findPresetBySlug(slug);
      if (preset != null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VenueDetailScreen(venuePreset: preset),
        );
      }
    }

    return MaterialPageRoute(
      settings: const RouteSettings(name: '/'),
      builder: (_) => const HomeScreen(),
    );
  }
}
