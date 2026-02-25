import 'package:flutter/material.dart';
import 'day_event.dart';

enum RecurrenceType { none, daily, weekly, monthly, yearly }

class AddDayEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  // onSave now returns a list of generated occurrences
  final Function(List<DayEvent>) onSave;

  const AddDayEventDialog({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<AddDayEventDialog> createState() => _AddDayEventDialogState();
}

class _AddDayEventDialogState extends State<AddDayEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  final TextEditingController _notesController = TextEditingController();
  DayEventType _selectedType = DayEventType.admin;
  late DateTime _selectedDate;
  RecurrenceType _recurrence = RecurrenceType.none;
  int _weeklyInterval = 1; // every N weeks
  final Set<int> _selectedWeekdays = {}; // 1..7 (Mon..Sun)
  int _monthlyInterval = 1; // every N months
  DateTime? _recurrenceEndDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _dateController = TextEditingController(text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
  }

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final notes = _notesController.text.isEmpty ? null : _notesController.text.trim();

      // Build occurrences according to recurrence
      final List<DayEvent> occurrences = [];
      final DateTime endDate = _recurrenceEndDate ?? DateTime(_selectedDate.year, 12, 31);

      DateTime clampEnd(DateTime d) => DateTime(d.year, d.month, d.day);

      if (_recurrence == RecurrenceType.none) {
        occurrences.add(DayEvent(date: _selectedDate, type: _selectedType, notes: notes));
      } else if (_recurrence == RecurrenceType.daily) {
        for (DateTime d = _selectedDate; !d.isAfter(endDate); d = d.add(const Duration(days: 1))) {
          occurrences.add(DayEvent(date: clampEnd(d), type: _selectedType, notes: notes));
        }
      } else if (_recurrence == RecurrenceType.weekly) {
        // if no weekdays chosen, default to start date's weekday
        final chosen = _selectedWeekdays.isEmpty ? {_selectedDate.weekday} : _selectedWeekdays;
        for (DateTime d = _selectedDate; !d.isAfter(endDate); d = d.add(const Duration(days: 1))) {
          final weeksSinceStart = (d.difference(_selectedDate).inDays) ~/ 7;
          if (chosen.contains(d.weekday) && weeksSinceStart % _weeklyInterval == 0 && !d.isBefore(_selectedDate)) {
            occurrences.add(DayEvent(date: clampEnd(d), type: _selectedType, notes: notes));
          }
        }
      } else if (_recurrence == RecurrenceType.monthly) {
        DateTime current = _selectedDate;
        while (!current.isAfter(endDate)) {
          // attempt to create same day in current month
          final day = _selectedDate.day;
          try {
            final maybe = DateTime(current.year, current.month, day);
            if (!maybe.isBefore(_selectedDate) && !maybe.isAfter(endDate)) occurrences.add(DayEvent(date: clampEnd(maybe), type: _selectedType, notes: notes));
          } catch (_) {}
          current = DateTime(current.year, current.month + _monthlyInterval, current.day);
        }
      } else if (_recurrence == RecurrenceType.yearly) {
        DateTime current = _selectedDate;
        while (!current.isAfter(endDate)) {
          occurrences.add(DayEvent(date: clampEnd(current), type: _selectedType, notes: notes));
          current = DateTime(current.year + 1, current.month, current.day);
        }
      }

      widget.onSave(occurrences);
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Day Event', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today), labelText: 'Date'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DayEventType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Type', prefixIcon: Icon(Icons.event)),
              items: DayEventType.values.map((t) => DropdownMenuItem(value: t, child: Text(t == DayEventType.admin ? 'Admin Day' : 'Leave Day'))).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedType = v);
              },
            ),
            const SizedBox(height: 12),
            // Recurrence controls
            DropdownButtonFormField<RecurrenceType>(
              initialValue: _recurrence,
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
              decoration: const InputDecoration(labelText: 'Notes (optional)', prefixIcon: Icon(Icons.note)),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _save, child: const Text('Save')),
              ],
            )
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Day Event')),
        body: SingleChildScrollView(child: content),
      );
    }

    return Dialog(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: content));
  }
}
