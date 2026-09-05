import 'dart:async';

import 'package:flutter/material.dart';

import '../services/queue_simulator.dart';
import '../services/time_tracker.dart';
import '../widgets/practice_back_button.dart';
import 'captcha_screen.dart';

class QueueScreen extends StatefulWidget {
  final TimeTracker timeTracker;
  final QueueSimulator? simulator;
  final String? venueId;

  const QueueScreen({
    super.key,
    required this.timeTracker,
    this.simulator,
    this.venueId,
  });

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  late final QueueSimulator _simulator;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _simulator = widget.simulator ?? QueueSimulator();
    _timer = Timer.periodic(const Duration(milliseconds: 300), _onTick);
  }

  void _onTick(Timer timer) {
    if (!mounted) return;
    _simulator.tick();
    if (_simulator.isComplete) {
      timer.cancel();
      widget.timeTracker.markQueueCompleted();
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => CaptchaScreen(
              timeTracker: widget.timeTracker,
              venueId: widget.venueId,
            ),
          ),
        );
      });
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nearlyDone = _simulator.isNearlyDone;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nearlyDone
                      ? '곧 순서가 다가옵니다'
                      : '접속 인원이 많아 대기 중입니다',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  nearlyDone ? '예매를 준비해주세요' : '조금만 기다려주세요',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: nearlyDone ? Colors.red : Colors.grey[600],
                    fontWeight: nearlyDone ? FontWeight.bold : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Text(
                  '나의 대기순서',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_simulator.currentNumber}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _simulator.progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    color: nearlyDone ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '현재 대기인원  ${_simulator.totalWaiting}명',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
            const Positioned(
              left: 12,
              top: 12,
              child: PracticeBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
