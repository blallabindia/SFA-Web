import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Map<String, String>? task;
  final Function(Map<String, String>) onSave;

  const AddTaskDialog({super.key, this.task, required this.onSave});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _relatedToController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _priority = "Medium";
  String _status = "Pending";

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _subjectController.text = widget.task!['subject'] ?? '';
      _dueDateController.text = widget.task!['dueDate'] ?? '';
      _priority = widget.task!['priority'] ?? 'Medium';
      _status = widget.task!['status'] ?? 'Pending';
      _relatedToController.text = widget.task!['relatedTo'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _dueDateController.dispose();
    _timeController.dispose();
    _relatedToController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        "subject": _subjectController.text,
        "dueDate": "${_dueDateController.text} ${_timeController.text}".trim(),
        "priority": _priority,
        "status": _status,
        "relatedTo": _relatedToController.text,
        "description": _descriptionController.text,
      };
      widget.onSave(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task != null ? "Edit Task" : "Add New Task"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subject
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Subject is required" : null,
                ),
                const SizedBox(height: 16),

                // Due Date & Time
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dueDateController,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: const InputDecoration(
                          labelText: "Due Date",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "Due Date is required"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: _pickTime,
                        decoration: const InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Priority & Status Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _priority,
                        decoration: const InputDecoration(
                          labelText: "Priority",
                          border: OutlineInputBorder(),
                        ),
                        items: ["High", "Medium", "Low"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _priority = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(),
                        ),
                        items: ["Pending", "In Progress", "Completed", "Deferred"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _status = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Related To
                TextFormField(
                  controller: _relatedToController,
                  decoration: const InputDecoration(
                    labelText: "Related To (Lead/Client)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(widget.task != null ? "Update Task" : "Save Task"),
        ),
      ],
    );
  }
}