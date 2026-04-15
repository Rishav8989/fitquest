import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

class EditFoodScreen extends StatefulWidget {
  final FoodItem foodItem;
  const EditFoodScreen({super.key, required this.foodItem});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late String mealType;
  
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _calCtrl;
  late TextEditingController _proCtrl;
  late TextEditingController _carbCtrl;
  late TextEditingController _fatCtrl;
  late TextEditingController _fibCtrl;
  late TextEditingController _srvCtrl;

  @override
  void initState() {
    super.initState();
    final f = widget.foodItem;
    mealType = f.mealType;
    
    _nameCtrl = TextEditingController(text: f.name);
    _calCtrl = TextEditingController(text: f.calories.toString());
    _proCtrl = TextEditingController(text: f.protein.toString());
    _carbCtrl = TextEditingController(text: f.carbs.toString());
    _fatCtrl = TextEditingController(text: f.fat.toString());
    _fibCtrl = TextEditingController(text: f.fiber.toString());
    _srvCtrl = TextEditingController(text: f.serving);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    _proCtrl.dispose();
    _carbCtrl.dispose();
    _fatCtrl.dispose();
    _fibCtrl.dispose();
    _srvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Food')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Food Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: mealType,
                decoration: const InputDecoration(
                  labelText: 'Meal type',
                ),
                items: _mealTypes
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => mealType = v ?? mealType),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _srvCtrl,
                decoration: const InputDecoration(labelText: 'Serving (e.g. 1 bowl, 200g)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _calCtrl,
                      decoration: const InputDecoration(labelText: 'Calories'),
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _proCtrl,
                      decoration: const InputDecoration(labelText: 'Protein (g)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _carbCtrl,
                      decoration: const InputDecoration(labelText: 'Carbs (g)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatCtrl,
                      decoration: const InputDecoration(labelText: 'Fat (g)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fibCtrl,
                      decoration: const InputDecoration(labelText: 'Fiber (g)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      final updatedFoodItem = widget.foodItem.copyWith(
                        name: _nameCtrl.text,
                        calories: int.parse(_calCtrl.text),
                        protein: int.parse(_proCtrl.text),
                        carbs: int.parse(_carbCtrl.text),
                        fat: int.parse(_fatCtrl.text),
                        fiber: int.parse(_fibCtrl.text),
                        mealType: mealType,
                        serving: _srvCtrl.text,
                      );
                      await context.read<AppState>().updateFood(updatedFoodItem);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

