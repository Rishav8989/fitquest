import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/data/massive_datasets.dart';

const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];



class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String? presetName;
  String mealType = _mealTypes.first;

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _proCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _fibCtrl = TextEditingController();
  final _srvCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start empty, let user search
  }

  void _fillWithPreset(Map<String, dynamic> m) {
    _nameCtrl.text = m['name'];
    _calCtrl.text = m['calories'].toString();
    _proCtrl.text = m['protein'].toString();
    _carbCtrl.text = m['carbs'].toString();
    _fatCtrl.text = m['fat'].toString();
    _fibCtrl.text = m['fiber'].toString();
    _srvCtrl.text = m['serving'];
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
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Autocomplete<Map<String, dynamic>>(
                displayStringForOption: (option) => option['name'],
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Map<String, dynamic>>.empty();
                  }
                  return MassiveDatasets.foods.where((food) {
                    return food['name'].toString().toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                  });
                },
                onSelected: (Map<String, dynamic> selection) {
                  setState(() {
                    _fillWithPreset(selection);
                  });
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  // Bind the external _nameCtrl to internal controller if empty to allow validation sync
                  textEditingController.addListener(() {
                    _nameCtrl.text = textEditingController.text;
                  });
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Search Food Database or enter Custom...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  );
                },
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  final nameVal = _nameCtrl.text;
                  final calVal = int.parse(_calCtrl.text);
                  
                  final item = FoodItem(
                    name: nameVal,
                    calories: calVal,
                    protein: int.parse(_proCtrl.text),
                    carbs: int.parse(_carbCtrl.text),
                    fat: int.parse(_fatCtrl.text),
                    fiber: int.parse(_fibCtrl.text),
                    serving: _srvCtrl.text,
                    mealType: mealType,
                    date: DateTime.now().toIso8601String(),
                  );
                  final ok = await showConfirmDialog(
                    context,
                    title: 'Add food?',
                    message: 'Add "$nameVal" ($calVal kcal) to your log?',
                    confirmText: 'Add',
                  );
                  if (ok && context.mounted) {
                    await context.read<AppState>().addFood(item);
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
