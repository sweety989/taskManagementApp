import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/backend_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controller for task title input field
  final TextEditingController _titleController = TextEditingController();

  // Default selected date
  DateTime _selectedDate = DateTime.now();

  // Function to select a due date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    // Update selected date if user picks a date
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text field for task title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            const SizedBox(height: 20.0),
            // Row for due date selection
            Row(
              children: <Widget>[
                const Text(
                  'Due date:',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 20.0),
                // Button to select due date
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    DateFormat.yMMMd().format(_selectedDate),
                    style: const TextStyle(fontSize: 16.0,
                        color: Colors.teal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Button to add task
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty) {
                  // Show error dialog if task title is empty
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Task title cannot be empty.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  try {
                    // Create a new task
                    Task newTask = Task(
                        title: _titleController.text.trim(),
                        dueDate: _selectedDate,
                        status: false,
                        id: ''
                    );
                    // Add task using BackendService
                    await BackendService.addTask(newTask);
                    // Return to previous screen with indication that task is added
                    Navigator.pop(context, newTask);
                  } catch (e) {
                    // Handle errors
                    print('Error adding task: $e');
                    // Show error message to user if needed
                  }
                }
              },
              child: const Text('Add task',
                style: TextStyle(
                    color: Colors.teal
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
