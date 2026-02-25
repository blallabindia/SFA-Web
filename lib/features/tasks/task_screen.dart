import 'package:flutter/material.dart';
import '../../shared/widgets/primary_button.dart';
import 'add_task_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // Dummy data
  final List<Map<String, String>> _tasks = [
    {
      "subject": "Follow up with Dr. Sharma",
      "dueDate": "12 Mar 2026",
      "priority": "High",
      "status": "Pending",
      "relatedTo": "Dr. Sharma (Lead)",
    },
    {
      "subject": "Send Quotation to Apollo",
      "dueDate": "14 Mar 2026",
      "priority": "Medium",
      "status": "In Progress",
      "relatedTo": "Apollo Hospital (Client)",
    },
    {
      "subject": "Submit Monthly Report",
      "dueDate": "30 Mar 2026",
      "priority": "Low",
      "status": "Pending",
      "relatedTo": "Internal",
    },
  ];

  void _openAddTaskDialog({int? index}) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        task: index != null ? _tasks[index] : null,
        onSave: (newTask) {
          setState(() {
            if (index != null) {
              _tasks[index] = newTask;
            } else {
              _tasks.add(newTask);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tasks",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              PrimaryButton(
                text: "Add Task",
                icon: Icons.add,
                onPressed: () => _openAddTaskDialog(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Task List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
            ),
            child: Column(
              children: [
                _buildHeaderRow(),
                ..._tasks.asMap().entries.map((e) => _buildTaskRow(e.key, e.value)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("Subject", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Related To", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Due Date", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Priority", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildTaskRow(int index, Map<String, String> task) {
    return InkWell(
      onTap: () => _openAddTaskDialog(index: index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(task["subject"]!)),
            Expanded(flex: 2, child: Text(task["relatedTo"]!)),
            Expanded(child: Text(task["dueDate"]!)),
            Expanded(child: Text(task["priority"]!)),
            Expanded(child: Text(task["status"]!)),
          ],
        ),
      ),
    );
  }
}