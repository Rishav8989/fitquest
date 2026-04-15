import os

file_path = '/home/server/etc/fitquest/lib/screens/add_food_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

# Replace imports
content = content.replace("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:fitquest/data/massive_datasets.dart';")

# Remove _indianMeals entirely
import re
content = re.sub(r'final _indianMeals = \[.*?\];', '', content, flags=re.DOTALL)

# Refactor _AddFoodScreenState
state_class_start = content.find('class _AddFoodScreenState extends State<AddFoodScreen> {')
if state_class_start != -1:
    old_init_state = '''  @override
  void initState() {
    super.initState();
    _fillWithPreset(_indianMeals.first);
  }

  void _fillWithPreset((String, int, int, int, int, int, String) m) {
    presetName = m.$1;
    _nameCtrl.text = m.$1;
    _calCtrl.text = m.$2.toString();
    _proCtrl.text = m.$3.toString();
    _carbCtrl.text = m.$4.toString();
    _fatCtrl.text = m.$5.toString();
    _fibCtrl.text = m.$6.toString();
    _srvCtrl.text = m.$7;
  }'''
    
    new_init_state = '''  @override
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
  }'''
    content = content.replace(old_init_state, new_init_state)

    old_dropdown = '''              DropdownButtonFormField<String>(
                value: presetName,
                decoration: const InputDecoration(
                  labelText: 'Quick Fill Preset',
                ),
                items: _indianMeals
                    .map((m) => DropdownMenuItem(
                          value: m.$1,
                          child: Text(m.$1),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  final m = _indianMeals.firstWhere((e) => e.$1 == v);
                  setState(() {
                    _fillWithPreset(m);
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Food Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),'''

    new_autocomplete = '''              Autocomplete<Map<String, dynamic>>(
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
              ),'''
    
    content = content.replace(old_dropdown, new_autocomplete)

with open(file_path, 'w') as f:
    f.write(content)

print('Updated add_food_screen.dart')
