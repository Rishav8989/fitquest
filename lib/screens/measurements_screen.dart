import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:intl/intl.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _armsCtrl = TextEditingController();
  final _thighsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    _chestCtrl.dispose();
    _waistCtrl.dispose();
    _armsCtrl.dispose();
    _thighsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  void _showAddMeasurementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Body Measurements'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField('Weight (kg)', _weightCtrl),
                _buildField('Chest (cm)', _chestCtrl),
                _buildField('Waist (cm)', _waistCtrl),
                _buildField('Arms (cm)', _armsCtrl),
                _buildField('Thighs (cm)', _thighsCtrl),
                _buildField('Body Fat % (optional)', _fatCtrl, required: false),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final bm = BodyMeasurement(
                  date: DateTime.now(),
                  weight: double.parse(_weightCtrl.text),
                  chest: double.parse(_chestCtrl.text),
                  waist: double.parse(_waistCtrl.text),
                  arms: double.parse(_armsCtrl.text),
                  thighs: double.parse(_thighsCtrl.text),
                  bodyFat: _fatCtrl.text.isNotEmpty ? double.tryParse(_fatCtrl.text) : null,
                );
                await context.read<AppState>().addMeasurement(bm);
                if (context.mounted) {
                  Navigator.pop(context);
                  _weightCtrl.clear();
                  _chestCtrl.clear();
                  _waistCtrl.clear();
                  _armsCtrl.clear();
                  _thighsCtrl.clear();
                  _fatCtrl.clear();
                }
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, isDense: true),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: required
            ? (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Invalid number';
                return null;
              }
            : (v) {
                if (v != null && v.isNotEmpty && double.tryParse(v) == null) return 'Invalid number';
                return null;
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final measurements = context.watch<AppState>().measurements;

    return Scaffold(
      appBar: AppBar(title: const Text('Body Measurements')),
      body: measurements.isEmpty
          ? const Center(child: Text('No measurements logged yet!'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                // Show newest first
                final m = measurements[measurements.length - 1 - index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMMMd().format(m.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatText('Weight', '${m.weight} kg'),
                            _StatText('Chest', '${m.chest} cm'),
                            _StatText('Waist', '${m.waist} cm'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatText('Arms', '${m.arms} cm'),
                            _StatText('Thighs', '${m.thighs} cm'),
                            _StatText('Body Fat', m.bodyFat != null ? '${m.bodyFat}%' : 'N/A'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMeasurementDialog,
        icon: const Icon(Icons.add),
        label: const Text('Log Measurements'),
      ),
    );
  }
}

class _StatText extends StatelessWidget {
  final String label;
  final String value;
  const _StatText(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ],
    );
  }
}
