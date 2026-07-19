import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock.dart';
import '../widgets/primitives.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int tab) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  void _showScoreFactorsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                "What's affecting your score",
                style: display(size: 20, weight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                "Built from your check-in trends, symptom answers, and reminder adherence.",
                style: body(size: 13.5, color: AppColors.mutedFg),
              ),
              const SizedBox(height: 20),
              ...scoreFactors.map((f) {
                final isPositive = f.effect > 0;
                final iconBg = isPositive ? AppColors.tier1 : AppColors.tier3;
                final iconFg = isPositive ? AppColors.tier1Solid : AppColors.tier3Solid;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPositive ? Icons.north_east_rounded : Icons.south_east_rounded,
                          size: 18,
                          color: iconFg,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.label, style: body(size: 14.5, weight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(f.subtitle, style: body(size: 12.5, color: AppColors.mutedFg)),
                          ],
                        ),
                      ),
                      Text(
                        "${isPositive ? '+' : ''}${f.effect}",
                        style: body(
                          size: 15,
                          weight: FontWeight.w600,
                          color: iconFg,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = family.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WEDNESDAY, 17 JULY",
                      style: body(size: 11.5, weight: FontWeight.w600, color: AppColors.mutedFg)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 2),
                    Text("Good morning, Aarav", style: display(size: 26, weight: FontWeight.w600)),
                  ],
                ),
              ),
              const _TextSizeToggle(),
            ],
          ),
        ),

        // Check-in CTA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppCard(
            onTap: () => onNavigate(1),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start today's check-in", style: body(size: 15, weight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        "Just talk — 30 seconds, no typing",
                        style: body(size: 13, color: AppColors.mutedFg),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.mutedFg, size: 20),
              ],
            ),
          ),
        ),

        // Health Score Card
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HealthScoreRing(score: me.healthScore),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Health score", style: display(size: 18, weight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.tier2,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  "Watch",
                                  style: body(size: 11.5, weight: FontWeight.w600, color: AppColors.tier2Fg),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Slightly down this week — your fasting sugar is trending up.",
                            style: body(size: 13, color: AppColors.mutedFg).copyWith(height: 1.35),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _showScoreFactorsBottomSheet(context),
                            child: Row(
                              children: [
                                Text(
                                  "What's affecting it",
                                  style: body(size: 13, weight: FontWeight.w600, color: AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Today's Care Section
        const _SectionLabel("Today's care", trailing: "2/4 done"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < reminders.length; i++) ...[
                  _ReminderRow(reminders[i]),
                  if (i != reminders.length - 1) const Divider(height: 1, color: AppColors.border),
                ]
              ],
            ),
          ),
        ),

        // Your Family Section
        _SectionLabel(
          "Your family",
          trailing: "View all",
          onTrailingTap: () => onNavigate(3),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: family.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final m = family[i];
              final dotColor = switch (m.tier) {
                1 => AppColors.tier1Solid,
                2 => AppColors.tier2Solid,
                _ => AppColors.tier3Solid,
              };
              return GestureDetector(
                onTap: () => onNavigate(3),
                child: Container(
                  width: 106,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              m.initials,
                              style: body(size: 14, weight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.name.split(" ").first,
                        style: body(size: 13, weight: FontWeight.w600),
                      ),
                      Text(m.relation, style: body(size: 11, color: AppColors.mutedFg)),
                      const Spacer(),
                      Text(
                        "Score ${m.healthScore}",
                        style: body(size: 11, weight: FontWeight.w600, color: AppColors.foreground),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Health Score Ring with "of 100" label matching screenshot ───────────────────

class _HealthScoreRing extends StatelessWidget {
  final int score;
  const _HealthScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      width: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 84,
            width: 84,
            child: CircularProgressIndicator(
              value: score / 100.0,
              strokeWidth: 7,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toString(),
                style: display(size: 24, weight: FontWeight.w700),
              ),
              Text(
                "of 100",
                style: body(size: 10, color: AppColors.mutedFg),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final Reminder r;
  const _ReminderRow(this.r);

  IconData get _icon => switch (r.kind) {
        "sun" => Icons.wb_sunny_outlined,
        "med" => Icons.medication_outlined,
        "ayurveda" => Icons.eco_outlined,
        _ => Icons.medical_services_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: body(
                    size: 14,
                    weight: FontWeight.w600,
                    color: r.done ? AppColors.mutedFg : AppColors.foreground,
                  ).copyWith(
                    decoration: r.done ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${r.detail} · ${r.time}",
                  style: body(size: 12, color: AppColors.mutedFg),
                ),
              ],
            ),
          ),
          Icon(
            r.done ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 22,
            color: r.done ? AppColors.primary : AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  const _SectionLabel(this.text, {this.trailing, this.onTrailingTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: display(size: 18, weight: FontWeight.w600)),
            if (trailing != null)
              GestureDetector(
                onTap: onTrailingTap,
                child: Row(
                  children: [
                    Text(
                      trailing!,
                      style: body(size: 12.5, weight: FontWeight.w600, color: AppColors.mutedFg),
                    ),
                    if (trailing!.contains("View")) ...[
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.mutedFg),
                    ],
                  ],
                ),
              ),
          ],
        ),
      );
}

class _TextSizeToggle extends StatelessWidget {
  const _TextSizeToggle();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Text("A", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.foreground)),
            ),
            const SizedBox(width: 8),
            const Text("A", style: TextStyle(fontSize: 14, color: AppColors.mutedFg)),
            const SizedBox(width: 8),
            const Text("A", style: TextStyle(fontSize: 16, color: AppColors.mutedFg)),
          ],
        ),
      );
}
