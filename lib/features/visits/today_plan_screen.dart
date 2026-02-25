import 'package:flutter/material.dart';
import 'visit_model.dart';
import 'add_visit_dialog.dart';
import 'visit_execution_screen.dart';
import 'day_event.dart';
import 'add_day_event_dialog.dart';
import 'visit_store.dart';

class TodayPlanScreen extends StatefulWidget {
  const TodayPlanScreen({super.key});

  @override
  State<TodayPlanScreen> createState() => _TodayPlanScreenState();
}

class _TodayPlanScreenState extends State<TodayPlanScreen> {
  DateTime _focusedDay = DateTime.now();

  // List to store visits
  final List<Visit> _visits = [
    Visit(
      date: DateTime.now(),
      accountName: "ABC Diagnostics",
      visitType: "Sales",
    ),
    Visit(
      date: DateTime.now(),
      accountName: "City Hospital",
      visitType: "Collection",
    ),
    Visit(
      date: DateTime.now().add(const Duration(days: 2)),
      accountName: "Dr. Sharma",
      visitType: "Service",
    ),
    Visit(
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountName: "Apollo Pharmacy",
      visitType: "Sales",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize store with initial visits
    VisitStore().addVisits(_visits);
  }

  bool _showDayEvents = true;

  // List to store day events (admin/leave)
  final List<DayEvent> _dayEvents = [];

  List<Visit> _getVisitsForDay(int day) {
    return _visits.where((visit) {
      return visit.date.year == _focusedDay.year &&
          visit.date.month == _focusedDay.month &&
          visit.date.day == day;
    }).toList();
  }

  void _prevMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  void _onAddVisit(DateTime selectedDate) {
    // If the day has an event (Leave/Admin), open the add-visit popup
    // so user can choose another date inside the dialog.
    final ev = _getDayEventForDate(selectedDate);
    if (ev != null) {
      final msg = ev.type == DayEventType.leave
          ? 'This day is marked as Leave. Please pick another date in the popup.'
          : 'This day is marked as Admin Day. You can pick another date in the popup.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    _showAddVisitDialog(selectedDate);
  }

  void _showAddVisitDialog(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) => AddVisitDialog(
        selectedDate: selectedDate,
        getDayEventForDate: (d) => _getDayEventForDate(d),
        onSave: (visits) {
          setState(() {
            int added = 0;
            int skipped = 0;
            for (final v in visits) {
              final exists = _visits.any((vv) => vv.date.year == v.date.year && vv.date.month == v.date.month && vv.date.day == v.date.day && vv.time == v.time && vv.accountName == v.accountName);
              if (!exists) {
                _visits.add(v);
                VisitStore().addVisit(v);
                added++;
              } else {
                skipped++;
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $added visit(s); skipped $skipped conflict(s).')));
          });
        },
      ),
    );
  }

  DayEvent? _getDayEventForDate(DateTime date) {
    try {
      return _dayEvents.firstWhere((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day);
    } catch (_) {
      return null;
    }
  }

  void _onAddDayEvent(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) => AddDayEventDialog(
        selectedDate: selectedDate,
        onSave: (evs) {
          setState(() {
            int added = 0;
            int skipped = 0;
            for (final ev in evs) {
              final exists = _dayEvents.any((d) => d.date.year == ev.date.year && d.date.month == ev.date.month && d.date.day == ev.date.day);
              if (!exists) {
                _dayEvents.add(ev);
                added++;
              } else {
                skipped++;
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $added event(s); skipped $skipped conflict(s).')));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Calendar"),
        actions: isMobile
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: () => _onAddVisit(DateTime.now()),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Visit"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: () => _onAddDayEvent(DateTime.now()),
                    icon: const Icon(Icons.event),
                    label: const Text("Add Day Event"),
                  ),
                ),
                IconButton(
                  tooltip: _showDayEvents ? 'Hide Day Events' : 'Show Day Events',
                  onPressed: () => setState(() => _showDayEvents = !_showDayEvents),
                  icon: Icon(_showDayEvents ? Icons.visibility : Icons.visibility_off),
                ),
                IconButton(
                  tooltip: 'Legend',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Legend'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: CircleAvatar(backgroundColor: dayEventColor(DayEventType.admin)),
                              title: const Text('Admin Day'),
                              subtitle: const Text('Internal / admin work day'),
                            ),
                            ListTile(
                              leading: CircleAvatar(backgroundColor: dayEventColor(DayEventType.leave)),
                              title: const Text('Leave Day'),
                              subtitle: const Text('Full-day leave; visits blocked'),
                            ),
                          ],
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                ),
              ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildDaysOfWeek(),
          Expanded(child: _buildCalendarGrid()),
        ],
      ),
      floatingActionButton: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'add_visit',
                  onPressed: () => _onAddVisit(DateTime.now()),
                  tooltip: 'Add Visit',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'add_day',
                  onPressed: () => _onAddDayEvent(DateTime.now()),
                  tooltip: 'Add Day Event',
                  child: const Icon(Icons.event),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildHeader() {
    final monthName = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][_focusedDay.month - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$monthName ${_focusedDay.year}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return Row(
      children: days
          .map((d) => Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: Text(d,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOffset = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday % 7;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.8,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: daysInMonth + firstDayOffset,
      itemBuilder: (context, index) {
        if (index < firstDayOffset) return const SizedBox();

        final day = index - firstDayOffset + 1;
        final visits = _getVisitsForDay(day);
        final isToday = day == DateTime.now().day && _focusedDay.month == DateTime.now().month && _focusedDay.year == DateTime.now().year;
        final cellDate = DateTime(_focusedDay.year, _focusedDay.month, day);

        return GestureDetector(
          onTap: () => _onAddVisit(cellDate),
          onLongPress: () => _onAddDayEvent(cellDate),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: isToday ? Colors.blue.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.blue : Colors.black,
                    ),
                  ),
                ),

                // Day event banner
                Builder(builder: (c) {
                  final de = _getDayEventForDate(cellDate);
                  if (de != null && _showDayEvents) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      color: dayEventColor(de.type).withOpacity(0.15),
                      child: Row(
                        children: [
                          Icon(de.type == DayEventType.leave ? Icons.beach_access : Icons.admin_panel_settings, size: 14, color: dayEventColor(de.type)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(de.type == DayEventType.leave ? 'Leave' : 'Admin Day', style: TextStyle(color: dayEventColor(de.type)))),
                          IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.edit, size: 16), onPressed: () => _onAddDayEvent(cellDate)),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete, size: 16),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Remove Day Event'),
                                  content: const Text('Remove this day event?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                setState(() {
                                  _dayEvents.removeWhere((d) => d.date.year == cellDate.year && d.date.month == cellDate.month && d.date.day == cellDate.day);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Visits list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: visits.length,
                    itemBuilder: (context, i) {
                      final visit = visits[i];
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => VisitExecutionScreen(
                              accountName: visit.accountName,
                              visitId: visit.id,
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: visit.typeColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: visit.typeColor.withOpacity(0.5)),
                          ),
                          child: Tooltip(
                            message: "${visit.accountName} (${visit.visitType})\n${visit.notes ?? 'No notes'}",
                            child: Text(
                              visit.accountName,
                              style: TextStyle(
                                fontSize: 10,
                                color: visit.typeColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
