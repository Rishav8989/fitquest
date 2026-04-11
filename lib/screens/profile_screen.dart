import 'package:fitquest/screens/edit_profile_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final p = appState.profile;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CircleAvatar(
                  radius: 50,
                  child: Icon(LucideIcons.user, size: 50),
                ),
                const SizedBox(height: 16),
                Text(
                  p.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  p.email,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                const SizedBox(height: 24),
                _buildProfileInfoRow(context, 'Age', '${p.age}'),
                _buildProfileInfoRow(context, 'Gender', p.gender),
                _buildProfileInfoRow(
                    context, 'Height', '${p.heightCm.toStringAsFixed(0)} cm'),
                _buildProfileInfoRow(
                    context, 'Weight', '${p.weightKg.toStringAsFixed(1)} kg'),
                _buildProfileInfoRow(
                    context, 'BMI', '${p.bmi.toStringAsFixed(1)}'),
                _buildProfileInfoRow(context, 'Activity Level', p.activityLevel),
                _buildProfileInfoRow(context, 'Diet Plan', p.dietPlan),
                _buildProfileInfoRow(context, 'Goal', p.goal),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
                  child: const Text('Edit Profile'),
                ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(LucideIcons.history),
              title: const Text('History & Analytics'),
              subtitle: const Text('View and export your data'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.info),
              title: const Text('About & Features'),
              subtitle: const Text('Use cases and feature list'),
              onTap: () => _showAboutAndFeatures(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.helpCircle),
              title: const Text('How to Use'),
              subtitle: const Text('Getting started and navigation'),
              onTap: () => _showHowToUse(context),
            ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showAboutAndFeatures(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'About & Features',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                _featureItem(context, 'Dark theme', 'Toggle in header'),
                _featureItem(context, 'Profile', 'Edit name, BMI, goals, diet'),
                _featureItem(context, 'Confirmations', 'Confirm food, exercise, delete'),
                _featureItem(context, 'Step tracking', 'From your phone sensor (Android), 10K goal'),
                _featureItem(context, 'AI recommendations', 'Time & context-aware tips'),
                _featureItem(context, 'India-specific', 'Indian meals, yoga, Ayurvedic tips'),
                _featureItem(context, 'Journey map', 'Routes, milestones, progress'),
                _featureItem(context, 'Gamification', 'Points, levels, streaks, achievements'),
                _featureItem(context, 'Data persistence', 'All data saved locally'),
                _featureItem(context, 'Nutrition', 'Calories, protein, carbs, fat, meals'),
                _featureItem(context, 'Exercise', 'Duration, type, calories, trends'),
                _featureItem(context, 'Sleep', 'Duration, quality, score, tips'),
                _featureItem(context, 'Activity', 'Steps, distance, active minutes'),
                _featureItem(context, 'Today vs history', 'Dashboard today; reports for trends'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _featureItem(BuildContext context, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.checkCircle2,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHowToUse(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'How to Use',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Getting started',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('• Dashboard (Home): view today’s stats'),
                const Text('• Start Step Tracking on dashboard'),
                const Text('• Log Food → choose meal or custom'),
                const Text('• Log Exercise → choose activity'),
                const Text('• AI tab: recommendations'),
                const Text('• User icon: edit profile'),
                const Text('• Sun/moon icon: toggle theme'),
                const SizedBox(height: 16),
                const Text(
                  'Navigation',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Home – dashboard summary'),
                const Text('Workout – exercise log'),
                const Text('Food – nutrition log & goals'),
                const Text('Progress – journey map & milestones'),
                const Text('AI – gamification & tips'),
                const Text('Profile – settings & about'),
                const SizedBox(height: 16),
                const Text(
                  'Try',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('• 10,000 steps → achievement'),
                const Text('• Log 3 meals → daily challenge'),
                const Text('• Diet plans in profile'),
                const Text('• Time-based AI tips'),
                const Text('• Daily streak by logging'),
              ],
            ),
          );
        },
      ),
    );
  }
}
