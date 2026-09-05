import 'package:flutter/material.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key});

  static const _navItems = [
    ('실전 티켓팅 연습', '/practice'),
    ('좌석 집중 연습', '/seat-practice'),
    ('포도알 연습', '/grape-practice'),
    ('공연장', '/'),
  ];

  void _navigateHome(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.popUntil((route) => route.isFirst);
    } else {
      nav.pushReplacementNamed('/');
    }
  }

  void _navigateTo(BuildContext context, String route) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.popUntil((route) => route.isFirst);
    }
    nav.pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showInlineNav = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 20,
        right: showInlineNav ? 20 : 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _navigateHome(context),
              child: Semantics(
                link: true,
                label: '홈으로 이동',
                child: Text(
                  '티켓팅캐치',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (showInlineNav)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in _navItems)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _navigateTo(context, item.$2),
                        child: Text(
                          item.$1,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            PopupMenuButton<String>(
              icon: Icon(Icons.menu, size: 22, color: Colors.grey[700]),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onSelected: (route) => _navigateTo(context, route),
              itemBuilder: (_) => [
                for (final item in _navItems)
                  PopupMenuItem(
                    value: item.$2,
                    child: Text(
                      item.$1,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
