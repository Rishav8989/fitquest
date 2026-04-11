import 'package:flutter/material.dart';

class RecommendationService {
  String getRecommendation(BuildContext context) {
    final hour = DateTime.now().hour;

    // Time-aware recommendations
    if (hour >= 5 && hour < 12) {
      return 'Good morning! Have you had a nutritious breakfast?';
    } else if (hour >= 12 && hour < 17) {
      return 'It\'s a great time for a quick walk. Have you logged your lunch?';
    } else if (hour >= 17 && hour < 21) {
      return 'Consider a light dinner and winding down. Don\'t forget to track your hydration!';
    } else {
      return 'Prepare for a good night\'s sleep. Avoid heavy meals before bed.';
    }
  }

  // Placeholder for context-aware recommendations (e.g., based on recent logs)
  String getContextAwareRecommendation({
    required BuildContext context,
    bool? loggedWorkout,
    bool? loggedFood,
    int? waterGlasses,
  }) {
    if (loggedWorkout == false) {
      return 'You haven\'t logged a workout today. A 30-min walk could be great!';
    }
    if (loggedFood == false) {
      return 'Remember to log your meals to keep track of your macros.';
    }
    if (waterGlasses != null && waterGlasses < 4) {
      return 'Stay hydrated! Have another glass of water.';
    }
    return 'Keep up the great work!';
  }
}