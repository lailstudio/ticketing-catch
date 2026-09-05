import 'package:flutter/material.dart';

class BreadcrumbItem {
  final String label;
  final String? route;

  const BreadcrumbItem(this.label, [this.route]);
}

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '>',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ),
              if (items[i].route != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final nav = Navigator.of(context);
                      if (nav.canPop()) {
                        nav.popUntil((route) => route.isFirst);
                      }
                      nav.pushReplacementNamed(items[i].route!);
                    },
                    child: Text(
                      items[i].label,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                )
              else
                Text(
                  items[i].label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
