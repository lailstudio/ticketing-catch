// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:flutter/material.dart';

class SeoFooter extends StatelessWidget {
  const SeoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Divider(height: 1, color: Colors.grey[200]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  Wrap(
                    spacing: 24,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: const [
                      _FooterLink(label: '실전 티켓팅 연습', route: '/practice'),
                      _FooterLink(label: '좌석 집중 연습', route: '/seat-practice'),
                      _FooterLink(label: '포도알 연습', route: '/grape-practice'),
                      _FooterLink(label: '공연장별 연습', route: '/'),
                      _FooterLink(label: '티켓팅 부적', route: '/ticketing-charm'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '티켓팅캐치',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '실전 감각을 키우는 티켓팅 연습 서비스',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 12),
                  const _ExternalFooterLink(
                    label: '개인정보처리방침',
                    url: 'https://lailstudio.github.io/privacy.html',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final String route;

  const _FooterLink({required this.label, required this.route});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.popUntil((route) => route.isFirst);
          }
          nav.pushReplacementNamed(widget.route);
        },
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            color: _hovered ? Theme.of(context).colorScheme.primary : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}

class _ExternalFooterLink extends StatefulWidget {
  final String label;
  final String url;

  const _ExternalFooterLink({required this.label, required this.url});

  @override
  State<_ExternalFooterLink> createState() => _ExternalFooterLinkState();
}

class _ExternalFooterLinkState extends State<_ExternalFooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => html.window.open(widget.url, '_blank'),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: _hovered ? Theme.of(context).colorScheme.primary : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
