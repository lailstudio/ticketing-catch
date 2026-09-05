import 'package:flutter/material.dart';

class AdSlot extends StatelessWidget {
  // AdSense 연결 시 이 slotId를 data-ad-slot 속성에 매핑
  final String slotId;

  const AdSlot({super.key, required this.slotId});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 468;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 728,
                minHeight: isNarrow ? 50 : 90,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFFAFAFA),
                ),
                alignment: Alignment.center,
                child: Text(
                  '광고',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    letterSpacing: 1,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
