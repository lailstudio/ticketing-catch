import 'package:flutter/material.dart';

class PracticeModeSection extends StatelessWidget {
  final VoidCallback onFullPractice;
  final VoidCallback onFocusedPractice;
  final VoidCallback? onQuickPractice;

  const PracticeModeSection({
    super.key,
    required this.onFullPractice,
    required this.onFocusedPractice,
    this.onQuickPractice,
  });

  @override
  Widget build(BuildContext context) {
    final descStyle = TextStyle(fontSize: 12, color: Colors.grey[500]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: onFullPractice,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('실전 티켓팅 연습'),
          ),
        ),
        const SizedBox(height: 6),
        Text('대기열 · CAPTCHA · 좌석 선택', style: descStyle),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: onFocusedPractice,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('좌석 집중 연습'),
          ),
        ),
        const SizedBox(height: 6),
        Text('좌석 선택부터 포도알 클릭까지 집중 연습', style: descStyle),
        if (onQuickPractice != null) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: onQuickPractice,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('포도알 연습'),
            ),
          ),
          const SizedBox(height: 4),
          Text('빠른 좌석 클릭 연습', style: descStyle),
        ],
      ],
    );
  }
}
