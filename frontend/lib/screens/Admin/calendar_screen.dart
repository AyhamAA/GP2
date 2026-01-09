import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime(2024, 12, 13);

  // Colors matched to the provided images
  final Color darkTeal = const Color(0xFF085D62); // Button color
  final Color lightTealAccent = const Color(
    0xFF34AFB7,
  ); // Icon selection border

  List<Task> tasks = [
    Task(
      date: DateTime(2024, 12, 13),
      time: '3:20PM',
      title: 'Oxycontin',
      status: 'Not Match yet',
      icon: Icons.medication,
    ),
    Task(
      date: DateTime(2024, 12, 13),
      time: '7:45PM',
      title: 'Patient bed',
      status: 'Matched to Dana Ahmad',
      icon: Icons.bed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDateTextField(),
          _buildDivider(),
          Expanded(child: _buildTasksList()),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildDateTextField() {
    final dateText =
        '${_getDayName(selectedDate.weekday)}, ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: dateText),
        decoration: InputDecoration(
          labelText: 'Select Date',
          prefixIcon: Icon(Icons.calendar_today, color: lightTealAccent),
          suffixIcon: Icon(Icons.arrow_drop_down, color: lightTealAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: lightTealAccent,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) setState(() => selectedDate = picked);
        },
      ),
    );
  }

  Widget _buildTasksList() {
    final filteredTasks = tasks
        .where(
          (t) =>
              t.date.year == selectedDate.year &&
              t.date.month == selectedDate.month &&
              t.date.day == selectedDate.day,
        )
        .toList();

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks for this day."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(filteredTasks[index]),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              task.time,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => task.isDone = !task.isDone),
                    child: Icon(
                      task.isDone ? Icons.check_circle : task.icon,
                      color: task.isDone ? Colors.green : lightTealAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        task.isEditing
                            ? TextField(
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: "Edit status...",
                                ),
                                onChanged: (val) => task.status = val,
                              )
                            : Text(
                                task.status,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      task.isEditing ? Icons.save : Icons.edit,
                      size: 20,
                      color: darkTeal,
                    ),
                    onPressed: () {
                      setState(() => task.isEditing = !task.isEditing);
                      if (!task.isEditing) _showSuccessDialog("Changes Saved!");
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => setState(() => tasks.remove(task)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _showAddTaskDialog,
          child: const Text(
            'Add Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- Styled Dialogs ---

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    IconData selectedIcon = Icons.medication;
    String? titleError;
    String? timeError;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Center(
            child: Text(
              "Add New Task",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
                  errorText: timeError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: lightTealAccent, // لون الساعة + الأزرار
                            onPrimary: Colors.white, // لون النص داخل الدائرة
                            onSurface: Colors.black, // لون النص العام
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setDialogState(() {
                      timeController.text = picked.format(context);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorText: titleError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    [
                      Icons.medication,
                      Icons.bed,
                      Icons.local_hospital,
                      Icons.medical_services,
                    ].map((icon) {
                      final isSelected = selectedIcon == icon;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedIcon = icon),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? lightTealAccent.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? lightTealAccent
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected ? lightTealAccent : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkTeal,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  setDialogState(() {
                    titleError = titleController.text.isEmpty
                        ? "Please fill the field"
                        : null;
                    timeError = timeController.text.isEmpty
                        ? "Please fill the field"
                        : null;
                  });
                  if (titleError == null && timeError == null) {
                    setState(() {
                      tasks.add(
                        Task(
                          date: selectedDate,
                          time: timeController.text,
                          title: titleController.text,
                          status: "Not Match yet",
                          icon: selectedIcon,
                        ),
                      );
                    });
                    Navigator.pop(context);
                    _showSuccessDialog("Task Assigned!");
                  }
                },
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) Navigator.of(context).pop();
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF5DB063),
                size: 120,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    final count = tasks.where((t) => t.date.day == selectedDate.day).length;
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: Text(
            "There are $count plans",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) =>
      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][weekday % 7];
  String _getMonthName(int month) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}

class Task {
  final DateTime date;
  final String time;
  final String title;
  String status;
  final IconData icon;
  bool isDone;
  bool isEditing;

  Task({
    required this.date,
    required this.time,
    required this.title,
    required this.status,
    required this.icon,
    this.isDone = false,
    this.isEditing = false,
  });
}
