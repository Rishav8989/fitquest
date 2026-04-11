import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneyMap extends StatelessWidget {
  const JourneyMap({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journey Map',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cs.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 40,
                    child: Icon(LucideIcons.flag, color: cs.primary),
                  ),
                  Positioned(
                    right: 20,
                    top: 40,
                    child: Icon(LucideIcons.flagTriangleRight, color: cs.tertiary),
                  ),
                  Positioned(
                    left: 60,
                    top: 40,
                    right: 60,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: cs.outline.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            height: 4,
                            width: constraints.maxWidth * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: cs.tertiary,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
