import 'package:flutter/material.dart';

class PlannerTask {
  String title;
  DateTime date;
  TimeOfDay? time;
  bool isCompleted;
  bool hasReminder;

  PlannerTask({
    required this.title,
    required this.date,
    this.time,
    this.isCompleted = false,
    this.hasReminder = false,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  final List<PlannerTask> _allTasks = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    
    // Add some sample data for today to showcase the unified feature
    _allTasks.add(PlannerTask(
      title: 'Morning Workout',
      date: _selectedDate,
      time: const TimeOfDay(hour: 7, minute: 0),
      hasReminder: true,
    ));
    _allTasks.add(PlannerTask(
      title: 'Drink 8 glasses of water',
      date: _selectedDate,
      hasReminder: false,
    ));
  }

  List<PlannerTask> get _tasksForSelectedDate {
    return _allTasks.where((task) =>
        task.date.year == _selectedDate.year &&
        task.date.month == _selectedDate.month &&
        task.date.day == _selectedDate.day).toList();
  }

  void _addTask() async {
    final titleController = TextEditingController();
    TimeOfDay? selectedTime;
    bool hasReminder = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Task description'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(selectedTime == null
                          ? 'Set Time (Optional)'
                          : selectedTime!.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedTime = time;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Set Reminder'),
                      value: hasReminder,
                      onChanged: (val) {
                        setDialogState(() {
                          hasReminder = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _allTasks.add(PlannerTask(
                          title: titleController.text,
                          date: _selectedDate,
                          time: selectedTime,
                          hasReminder: hasReminder,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _tasksForSelectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner & Tasks'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime date) {
              setState(() {
                _selectedDate = DateTime(date.year, date.month, date.day);
              });
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks for this day.\nTap + to add one.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                                                final task = tasks[index];
                                                return Dismissible(
                                                  key: ValueKey(task.title + task.date.toString() + task.time.toString()), // Unique key for Dismissible
                                                  direction: DismissDirection.endToStart,
                                                  background: Container(
                                                    alignment: Alignment.centerRight,
                                                    padding: const EdgeInsets.only(right: 20),
                                                    color: Colors.red,
                                                    child: const Icon(Icons.delete, color: Colors.white),
                                                  ),
                                                  onDismissed: (direction) {
                                                    setState(() {
                                                      _allTasks.remove(task);
                                                    });
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('${task.title} dismissed')),
                                                    );
                                                  },
                                                  child: CheckboxListTile(
                                                    title: Text(
                                                      task.title,
                                                      style: TextStyle(
                                                        decoration: task.isCompleted
                                                            ? TextDecoration.lineThrough
                                                            : null,
                                                      ),
                                                    ),
                                                    subtitle: task.time != null
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                task.hasReminder ? Icons.notifications_active : Icons.access_time,
                                                                size: 14,
                                                                color: task.hasReminder
                                                                    ? Theme.of(context).colorScheme.primary
                                                                    : Colors.grey,
                                                              ),
                                                              const SizedBox(width: 4),
                                                              Text(task.time!.format(context)),
                                                            ],
                                                          )
                                                        : null,
                                                    value: task.isCompleted,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        task.isCompleted = value ?? false;
                                                      });
                                                    },
                                                  ),
                                                );                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}