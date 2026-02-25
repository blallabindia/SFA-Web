import 'package:flutter/material.dart';
import 'package:sfa_ui_flutter/features/visits/day_event.dart';
import 'package:sfa_ui_flutter/features/visits/visit_model.dart';

enum RecurrenceType { none, daily, weekly, monthly, yearly }

class AddVisitDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(List<Visit>) onSave;
  final DayEvent? Function(DateTime)? getDayEventForDate;

  AddVisitDialog({
    Key? key,
    required this.selectedDate,
    required this.onSave,
    this.getDayEventForDate,
  }) : super(key: key);

  @override
  State<AddVisitDialog> createState() => _AddVisitDialogState();
}

class _AddVisitDialogState extends State<AddVisitDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late DateTime _selectedDate;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedVisitType;
  TimeOfDay? _selectedTime;
  List<String> _selectedJointWorking = [];

  RecurrenceType _recurrence = RecurrenceType.none;
  int _weeklyInterval = 1;
  Set<int> _selectedWeekdays = {};
  int _monthlyInterval = 1;
  DateTime? _recurrenceEndDate;

  static const List<String> visitTypes = ['Sales', 'Collection', 'Service', 'Meeting', 'Demo', 'Admin Day', 'Leave Day'];
  static const List<String> _salesPersons = ['ASM - Raj', 'RM - Karan', 'Sales - Amit', 'Sales - Sumit'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _dateController = TextEditingController(
      text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
    );
    _timeController = TextEditingController();
    _selectedVisitType = visitTypes.first;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _accountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _openJointWorkingDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        final tempSelected = List<String>.from(_selectedJointWorking);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Joint Working"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: _salesPersons.map((person) {
                    return CheckboxListTile(
                      value: tempSelected.contains(person),
                      title: Text(person),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(person);
                          } else {
                            tempSelected.remove(person);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.setState(() {
                      _selectedJointWorking = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final notes = _notesController.text.isEmpty ? null : _notesController.text.trim();
      String accountName = _accountController.text.trim();
      if (_selectedVisitType == 'Admin Day' || _selectedVisitType == 'Leave Day') {
        accountName = _selectedVisitType!;
      }

      final List<Visit> occurrences = [];
      final DateTime endDate = _recurrenceEndDate ?? DateTime(_selectedDate.year, 12, 31);
      DateTime clampEnd(DateTime d) => DateTime(d.year, d.month, d.day);
      final checker = widget.getDayEventForDate;

      bool isBlocked(DateTime d) {
        if (checker == null) return false;
        final ev = checker(d);
        return ev != null;
      }

      if (_recurrence == RecurrenceType.none) {
        if (!isBlocked(_selectedDate)) {
          occurrences.add(Visit(
            date: _selectedDate,
            time: _selectedTime,
            accountName: accountName,
            visitType: _selectedVisitType!,
            notes: notes,
            jointWorkingWith: _selectedJointWorking,
          ));
        }
      } else if (_recurrence == RecurrenceType.daily) {
        for (DateTime d = _selectedDate; !d.isAfter(endDate); d = d.add(const Duration(days: 1))) {
          if (!isBlocked(d)) {
            occurrences.add(Visit(
              date: clampEnd(d),
              time: _selectedTime,
              accountName: accountName,
              visitType: _selectedVisitType!,
              notes: notes,
              jointWorkingWith: _selectedJointWorking,
            ));
          }
        }
      } else if (_recurrence == RecurrenceType.weekly) {
        final chosen = _selectedWeekdays.isEmpty ? {_selectedDate.weekday} : _selectedWeekdays;
        for (DateTime d = _selectedDate; !d.isAfter(endDate); d = d.add(const Duration(days: 1))) {
          final weeksSinceStart = (d.difference(_selectedDate).inDays) ~/ 7;
          if (chosen.contains(d.weekday) && weeksSinceStart % _weeklyInterval == 0 && !d.isBefore(_selectedDate) && !isBlocked(d)) {
            occurrences.add(Visit(
              date: clampEnd(d),
              time: _selectedTime,
              accountName: accountName,
              visitType: _selectedVisitType!,
              notes: notes,
              jointWorkingWith: _selectedJointWorking,
            ));
          }
        }
      } else if (_recurrence == RecurrenceType.monthly) {
        DateTime current = _selectedDate;
        while (!current.isAfter(endDate)) {
          final day = _selectedDate.day;
          try {
            final maybe = DateTime(current.year, current.month, day);
            if (!maybe.isBefore(_selectedDate) && !maybe.isAfter(endDate) && !isBlocked(maybe)) {
              occurrences.add(Visit(
                date: clampEnd(maybe),
                time: _selectedTime,
                accountName: accountName,
                visitType: _selectedVisitType!,
                notes: notes,
                jointWorkingWith: _selectedJointWorking,
              ));
            }
          } catch (_) {}
          current = DateTime(current.year, current.month + _monthlyInterval, current.day);
        }
      } else if (_recurrence == RecurrenceType.yearly) {
        DateTime current = _selectedDate;
        while (!current.isAfter(endDate)) {
          if (!isBlocked(current)) {
            occurrences.add(Visit(
              date: clampEnd(current),
              time: _selectedTime,
              accountName: accountName,
              visitType: _selectedVisitType!,
              notes: notes,
              jointWorkingWith: _selectedJointWorking,
            ));
          }
          current = DateTime(current.year + 1, current.month, current.day);
        }
      }

      if (occurrences.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('No visits added'),
            content: const Text('All selected dates are blocked by Day Events.'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
        return;
      }

      widget.onSave(occurrences);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return _buildMobileUI();
    } else {
      return _buildDialogUI();
    }
  }

  Widget _buildDialogUI() {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: _buildFormContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileUI() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Visit"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildFormContent(),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 8,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            child: const Text("Save Visit"),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            "Plan New Visit",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Date (selectable)
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelText: "Date",
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Selection
          TextFormField(
            controller: _timeController,
            readOnly: true,
            onTap: _pickTime,
            decoration: InputDecoration(
              labelText: "Time (Optional)",
              prefixIcon: const Icon(Icons.access_time),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "Tap to select time",
            ),
          ),
          const SizedBox(height: 16),

          // Account Name
          if (_selectedVisitType != 'Admin Day' && _selectedVisitType != 'Leave Day') ...[
            TextFormField(
              controller: _accountController,
              decoration: InputDecoration(
                labelText: "Account Name *",
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Enter or select account",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Account name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          // Visit Type Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedVisitType,
            decoration: InputDecoration(
              labelText: "Visit Type *",
              prefixIcon: const Icon(Icons.flag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: visitTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Visit.fromType(type).typeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedVisitType = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Joint Working With
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: _selectedJointWorking.join(", ")),
            decoration: InputDecoration(
              labelText: "Joint Working With",
              prefixIcon: const Icon(Icons.people),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "Select sales persons",
            ),
            onTap: _openJointWorkingDialog,
          ),
          const SizedBox(height: 16),

          // Recurrence controls
          DropdownButtonFormField<RecurrenceType>(
            value: _recurrence,
            decoration: const InputDecoration(labelText: 'Repeat', prefixIcon: Icon(Icons.repeat)),
            items: [
              DropdownMenuItem(value: RecurrenceType.none, child: Text('Does not repeat')),
              DropdownMenuItem(value: RecurrenceType.daily, child: Text('Daily')),
              DropdownMenuItem(value: RecurrenceType.weekly, child: Text('Weekly')),
              DropdownMenuItem(value: RecurrenceType.monthly, child: Text('Monthly')),
              DropdownMenuItem(value: RecurrenceType.yearly, child: Text('Yearly')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _recurrence = v);
            },
          ),

          if (_recurrence == RecurrenceType.weekly) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Text('Every'),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextFormField(
                  initialValue: _weeklyInterval.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(),
                  onChanged: (v) => setState(() => _weeklyInterval = int.tryParse(v) ?? 1),
                ),
              ),
              const SizedBox(width: 8),
              const Text('week(s) on:'),
            ]),
            Wrap(
              spacing: 6,
              children: List.generate(7, (i) {
                final weekday = i + 1; // Monday=1
                final label = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][i];
                final selected = _selectedWeekdays.contains(weekday);
                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (s) => setState(() {
                    if (s) _selectedWeekdays.add(weekday); else _selectedWeekdays.remove(weekday);
                  }),
                );
              }),
            ),
          ],

          if (_recurrence == RecurrenceType.monthly) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Text('Every'),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextFormField(
                  initialValue: _monthlyInterval.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(),
                  onChanged: (v) => setState(() => _monthlyInterval = int.tryParse(v) ?? 1),
                ),
              ),
              const SizedBox(width: 8),
              const Text('month(s) on day'),
              const SizedBox(width: 8),
              Text('${_selectedDate.day}'),
            ]),
          ],

          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            minLines: 2,
            decoration: InputDecoration(
              labelText: "Notes (Optional)",
              prefixIcon: const Icon(Icons.note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "Add any additional notes...",
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Checkbox(
              value: _recurrenceEndDate != null,
              onChanged: (v) => setState(() => _recurrenceEndDate = v == true ? DateTime(_selectedDate.year, 12, 31) : null),
            ),
            const SizedBox(width: 8),
            const Text('End by specific date'),
            const SizedBox(width: 8),
            if (_recurrenceEndDate != null)
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(context: context, initialDate: _recurrenceEndDate!, firstDate: _selectedDate, lastDate: DateTime(2100));
                  if (picked != null) setState(() => _recurrenceEndDate = picked);
                },
                child: Text('${_recurrenceEndDate!.day}/${_recurrenceEndDate!.month}/${_recurrenceEndDate!.year}'),
              ),
          ]),
          const SizedBox(height: 24),

          // Action Buttons (for web/desktop)
          if (MediaQuery.of(context).size.width >= 600)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("Save Visit"),
                ),
              ],
            ),
        ],
      ),
    );
  }
}