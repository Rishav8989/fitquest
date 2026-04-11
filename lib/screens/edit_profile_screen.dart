import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isOnboarding;
  const EditProfileScreen({super.key, this.isOnboarding = false});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProfile p;
  late String name;
  late String email;
  late int age;
  late String gender;
  late double heightCm;
  late double weightKg;
  late String activityLevel;
  late String dietPlan;
  late String goal;
  
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    p = context.read<AppState>().profile;
    name = p.name;
    email = p.email;
    age = p.age;
    gender = p.gender;
    heightCm = p.heightCm;
    weightKg = p.weightKg;
    activityLevel = p.activityLevel;
    dietPlan = p.dietPlan;
    goal = p.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? 'Setup Your Profile' : 'Edit Profile'),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (v) => name = v,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
                onChanged: (v) => email = v,
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Invalid age';
                  return null;
                },
                onChanged: (v) => age = int.tryParse(v) ?? age,
              ),
              DropdownButtonFormField<String>(
                value: gender.isEmpty ? 'Male' : gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) => gender = v ?? gender,
              ),
              TextFormField(
                initialValue: heightCm.toString(),
                decoration:
                    const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Invalid height';
                  return null;
                },
                onChanged: (v) =>
                    heightCm = double.tryParse(v) ?? heightCm,
              ),
              TextFormField(
                initialValue: weightKg.toString(),
                decoration:
                    const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Invalid weight';
                  return null;
                },
                onChanged: (v) =>
                    weightKg = double.tryParse(v) ?? weightKg,
              ),
              DropdownButtonFormField<String>(
                value: activityLevel.isEmpty ? 'Sedentary' : activityLevel,
                decoration: const InputDecoration(labelText: 'Activity Level'),
                items: const [
                  DropdownMenuItem(value: 'Sedentary', child: Text('Sedentary')),
                  DropdownMenuItem(value: 'Lightly Active', child: Text('Lightly Active')),
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Very Active', child: Text('Very Active')),
                ],
                onChanged: (v) => activityLevel = v ?? activityLevel,
              ),
              DropdownButtonFormField<String>(
                value: dietPlan.isEmpty ? 'Balanced' : dietPlan,
                decoration: const InputDecoration(labelText: 'Diet Plan'),
                items: const [
                  DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
                  DropdownMenuItem(value: 'Keto', child: Text('Keto')),
                  DropdownMenuItem(value: 'Vegan', child: Text('Vegan')),
                  DropdownMenuItem(value: 'Vegetarian', child: Text('Vegetarian')),
                  DropdownMenuItem(value: 'Paleo', child: Text('Paleo')),
                ],
                onChanged: (v) => dietPlan = v ?? dietPlan,
              ),
              DropdownButtonFormField<String>(
                value: goal.isEmpty ? 'Maintain Weight' : goal,
                decoration: const InputDecoration(labelText: 'Goal'),
                items: const [
                  DropdownMenuItem(value: 'Lose Weight', child: Text('Lose Weight')),
                  DropdownMenuItem(value: 'Maintain Weight', child: Text('Maintain Weight')),
                  DropdownMenuItem(value: 'Build Muscle', child: Text('Build Muscle')),
                ],
                onChanged: (v) => goal = v ?? goal,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!widget.isOnboarding)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  context.read<AppState>().updateProfile(UserProfile(
                    name: name,
                    email: email,
                    age: age,
                    gender: gender,
                    heightCm: heightCm,
                    weightKg: weightKg,
                    activityLevel: activityLevel,
                    dietPlan: dietPlan,
                    goal: goal,
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
