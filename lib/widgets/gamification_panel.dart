import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GamificationPanel extends StatelessWidget {
  const GamificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gamification',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, 'Points', '850', LucideIcons.star),
                _buildStat(context, 'Level', '9', LucideIcons.trophy),
                _buildStat(context, 'Streak', '15', LucideIcons.flame),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Achievements',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAchievement(
                context, 'First Entry', 'Log your first meal', true),
            _buildAchievement(
                context, 'Week Warrior', 'Log meals for 7 days straight', true),
            _buildAchievement(context, '10K Steps', 'Reach 10,000 steps in a day', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, size: 32, color: cs.primary),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: cs.onSurface)),
        Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildAchievement(
      BuildContext context, String title, String description, bool unlocked) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        unlocked ? LucideIcons.checkCircle2 : LucideIcons.circle,
        color: unlocked ? cs.tertiary : cs.onSurfaceVariant,
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Icon(
        unlocked ? LucideIcons.unlock : LucideIcons.lock,
        color: unlocked ? cs.tertiary : cs.onSurfaceVariant,
      ),
    );
  }
}
