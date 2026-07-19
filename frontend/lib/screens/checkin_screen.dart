import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock.dart';
import '../widgets/primitives.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  int _step = 0;
  bool _listening = false;
  bool _done = false;
  final List<String> _answers = [];

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _answer(String chip) {
    setState(() {
      _answers.add(chip);
      _listening = false;
      if (_step < checkInScript.length - 1) {
        _step++;
      } else {
        _done = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _summary();
    final script = checkInScript[_step];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenHeader(eyebrow: "DAILY VOICE CHECK-IN", title: "Let's talk"),
                  const SizedBox(height: 8),

                  // Assistant question bubble
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        script["q"] as String,
                        style: body(size: 16, weight: FontWeight.w500),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom area (mic, instructions, chips, keyboard fallback)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pulse & Mic Button
                        GestureDetector(
                          onTap: () => setState(() => _listening = !_listening),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_listening)
                                  AnimatedBuilder(
                                    animation: _pulse,
                                    builder: (context, child) => Container(
                                      height: 100 * (0.7 + _pulse.value * 0.5),
                                      width: 100 * (0.7 + _pulse.value * 0.5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withValues(alpha: 0.2 * (1 - _pulse.value)),
                                      ),
                                    ),
                                  ),
                                Container(
                                  height: 72,
                                  width: 72,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x28000000),
                                        blurRadius: 14,
                                        offset: Offset(0, 6),
                                      )
                                    ],
                                  ),
                                  child: const Icon(Icons.mic_rounded, size: 32, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _listening ? "Listening… tap to stop" : "Tap to speak your answer",
                          style: body(size: 13.5, color: AppColors.mutedFg),
                        ),
                        const SizedBox(height: 20),

                        // Chips
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            for (final chip in (script["chips"] as List))
                              GestureDetector(
                                onTap: () => _answer(chip as String),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: const [
                                      BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                                    ],
                                  ),
                                  child: Text(
                                    chip as String,
                                    style: body(size: 14, weight: FontWeight.w500),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Type instead button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.keyboard_outlined, size: 18, color: AppColors.mutedFg),
                                const SizedBox(width: 8),
                                Text(
                                  "Type instead",
                                  style: body(size: 14, weight: FontWeight.w500, color: AppColors.foreground),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _summary() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(eyebrow: "DAILY VOICE CHECK-IN", title: "All done — nice work"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text("Today's check-in logged", style: display(size: 18, weight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      for (var i = 0; i < _answers.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "• ${checkInScript[i]["q"]} — ${_answers[i]}",
                            style: body(size: 13.5, color: AppColors.mutedFg),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Synced from your wearable",
                        style: body(size: 12.5, weight: FontWeight.w600, color: AppColors.mutedFg),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Metric("6,240", "steps"),
                          _Metric("62", "bpm rest"),
                          _Metric("6.1h", "sleep"),
                          _Metric("97%", "SpO₂"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  "Back to check-in",
                  icon: Icons.refresh_rounded,
                  secondary: true,
                  onTap: () => setState(() {
                    _done = false;
                    _step = 0;
                    _answers.clear();
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value, label;
  const _Metric(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: display(size: 18, weight: FontWeight.w600)),
          Text(label, style: body(size: 11.5, color: AppColors.mutedFg)),
        ],
      );
}
