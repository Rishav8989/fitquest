import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitquest/widgets/habit_tracker.dart';

class EditHabitsScreen extends StatefulWidget {
  final List<Habit> initialHabits;

  const EditHabitsScreen({super.key, required this.initialHabits});

  @override
  State<EditHabitsScreen> createState() => _EditHabitsScreenState();
}

class _EditHabitsScreenState extends State<EditHabitsScreen> {
  late List<Habit> _habits;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _habits = List.from(widget.initialHabits);
  }

  void _addHabit(String name) {
    if (name.trim().isEmpty) return;
    final newHabit = Habit(name: name, icon: LucideIcons.star, isCompleted: false);
    _habits.add(newHabit);
    _listKey.currentState?.insertItem(_habits.length - 1);
  }

  void _removeHabit(int index) {
    final removedHabit = _habits[index];
    _habits.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedHabit, animation, index),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildItem(Habit habit, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(habit.name),
        trailing: IconButton(
          icon: const Icon(LucideIcons.trash, color: Colors.red),
          onPressed: () => _removeHabit(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_habits),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _habits.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_habits[index], animation, index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(LucideIcons.plus),
              label: const Text('Add Habit'),
              onPressed: () async {
                String newHabit = '';
                bool added = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('New Habit'),
                    content: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Habit Name'),
                      onChanged: (v) => newHabit = v,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          if (newHabit.trim().isNotEmpty) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ) ?? false;

                if (added && newHabit.isNotEmpty) {
                  _addHabit(newHabit);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
