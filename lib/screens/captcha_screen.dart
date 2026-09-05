import 'package:flutter/material.dart';

import '../data/venue_data_registry.dart';
import '../models/practice_config.dart';
import '../models/venue.dart';
import '../services/captcha_generator.dart';
import '../services/time_tracker.dart';
import '../widgets/captcha_image.dart';
import '../widgets/practice_back_button.dart';
import 'venue_map_screen.dart';

class CaptchaScreen extends StatefulWidget {
  final TimeTracker timeTracker;
  final String? initialAnswer;
  final PracticeConfig config;
  final VenueData? venueOverride;
  final String? venueId;

  VenueData get venue => venueOverride ?? venueDataFor(venueId);

  const CaptchaScreen({
    super.key,
    required this.timeTracker,
    this.initialAnswer,
    this.config = const PracticeConfig(),
    this.venueOverride,
    this.venueId,
  });

  @override
  State<CaptchaScreen> createState() => _CaptchaScreenState();
}

class _CaptchaScreenState extends State<CaptchaScreen> {
  final _generator = CaptchaGenerator();
  final _controller = TextEditingController();
  late String _answer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _answer = widget.initialAnswer ?? _generator.generate();
    widget.timeTracker.markCaptchaEntered();
  }

  void _refresh() {
    setState(() {
      _answer = _generator.generate();
      _controller.clear();
      _errorMessage = null;
    });
  }

  void _submit() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    if (_generator.validate(input, _answer)) {
      widget.timeTracker.markCaptchaCompleted();
      widget.timeTracker.markSectionEntered();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VenueMapScreen(
            timeTracker: widget.timeTracker,
            config: widget.config,
            venue: widget.venue,
            venueId: widget.venueId,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = '문자가 일치하지 않습니다. 다시 입력해주세요.';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const PracticeBackButton(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // 안심예매 배지
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 18,
                                color: Colors.teal[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '안심예매',
                                style: TextStyle(
                                  color: Colors.teal[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 타이틀
                        Text(
                          '문자를 입력해주세요',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[400],
                              ),
                        ),
                        const SizedBox(height: 24),
                        // CAPTCHA 이미지 + 버튼
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CaptchaImage(text: _answer),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              onPressed: _refresh,
                              icon: const Icon(Icons.refresh),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 입력 필드
                        TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: '문자를 입력해주세요 (대소문자구분없음)',
                            border: const OutlineInputBorder(),
                            errorText: _errorMessage,
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 16),
                        // 입력완료 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: const Text(
                              '입력완료',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 안내 문구
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '• 부정예매방지를 위해 화면의 문자를 입력해주세요.\n'
                            '• 인증 후 좌석을 선택할 수 있습니다.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
