import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_planned_visit_dialog.dart';
import 'visits_mobile_screen.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  DateTime _selectedDate = DateTime.now();
  // Start calendar from a few days ago to show context
  final DateTime _startDate = DateTime.now().subtract(const Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 800) {
      return const VisitsMobileScreen();
    }

    final visits = _getVisitsForDate(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendarStrip(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: visits.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      return _buildVisitItem(visits[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddPlannedVisitDialog(),
          );
        },
        backgroundColor: const Color(0xFF5B5FC7), // Teams Blurple
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM').format(_selectedDate),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('yyyy').format(_selectedDate),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              icon: const Icon(Icons.calendar_month, color: Color(0xFF5B5FC7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = _startDate.add(Duration(days: index));
          final isSelected = isSameDay(date, _selectedDate);
          final isToday = isSameDay(date, DateTime.now());

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 54,
              margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5B5FC7) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFF5B5FC7), width: 1.5)
                    : Border.all(color: Colors.grey.shade200),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: const Color(0xFF5B5FC7).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 1),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisitItem(Map<String, dynamic> visit) {
    final DateTime start = visit['startTime'] as DateTime;
    final DateTime end = visit['endTime'] as DateTime;
    final Color color = visit['color'] as Color;
    final Color accentColor = visit['accentColor'] as Color;
    final Color textColor = visit['textColor'] as Color;
    final String title = visit['title'] as String;
    final String account = visit['account'] as String;
    final String type = visit['type'] as String;

    final startTime = DateFormat('hh:mm a').format(start);
    final duration = end.difference(start).inMinutes;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                startTime,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: BorderSide(color: accentColor, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.business, size: 14, color: textColor),
                      const SizedBox(width: 4),
                      Text(
                        account,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "$duration min",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_available,
                size: 48, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            "No visits planned for today",
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddPlannedVisitDialog(),
              );
            },
            child: const Text("Schedule a Visit"),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getVisitsForDate(DateTime date) {
    // Mock data logic
    if (date.day % 2 == 0) {
      return [
        {
          "account": "Apollo Hospital",
          "title": "Product Demo",
          "startTime": DateTime(date.year, date.month, date.day, 10, 0),
          "endTime": DateTime(date.year, date.month, date.day, 11, 0),
          "type": "Sales",
          "color": const Color(0xFFE0E7FF), // Light Indigo
          "accentColor": const Color(0xFF4338CA), // Dark Indigo
          "textColor": const Color(0xFF312E81),
        },
        {
          "account": "Sterling Labs",
          "title": "Contract Renewal",
          "startTime": DateTime(date.year, date.month, date.day, 14, 30),
          "endTime": DateTime(date.year, date.month, date.day, 15, 30),
          "type": "Negotiation",
          "color": const Color(0xFFFEF3C7), // Light Amber
          "accentColor": const Color(0xFFD97706), // Dark Amber
          "textColor": const Color(0xFF78350F),
        },
      ];
    } else if (date.day % 3 == 0) {
      return [];
    } else {
      return [
        {
          "account": "Dr. Sharma Clinic",
          "title": "Courtesy Visit",
          "startTime": DateTime(date.year, date.month, date.day, 11, 0),
          "endTime": DateTime(date.year, date.month, date.day, 11, 30),
          "type": "Courtesy",
          "color": const Color(0xFFDCFCE7), // Light Emerald
          "accentColor": const Color(0xFF059669), // Dark Emerald
          "textColor": const Color(0xFF064E3B),
        },
      ];
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}