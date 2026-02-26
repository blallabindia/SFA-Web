import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitsMobileScreen extends StatefulWidget {
  const VisitsMobileScreen({super.key});

  @override
  State<VisitsMobileScreen> createState() => _VisitsMobileScreenState();
}

class _VisitsMobileScreenState extends State<VisitsMobileScreen> {
  late DateTime _selectedDate;
  late final List<DateTime> _dates;
  final Map<DateTime, List<VisitModel>> _visits = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Normalize to midnight to ensure accurate map lookups
    _selectedDate = DateTime(now.year, now.month, now.day);
    _generateDates();
    _generateDummyVisits();
  }

  void _generateDates() {
    // Start 2 days ago, show 30 days total
    final start = _selectedDate.subtract(const Duration(days: 2));
    _dates = List.generate(30, (index) => start.add(Duration(days: index)));
  }

  void _generateDummyVisits() {
    // Helper to add visits safely
    void add(DateTime date, String account, String time, String status, String location) {
      final d = DateTime(date.year, date.month, date.day);
      if (!_visits.containsKey(d)) {
        _visits[d] = [];
      }
      _visits[d]!.add(VisitModel(account, time, status, location));
    }

    // Today's Visits
    add(_selectedDate, "Apollo Hospital", "10:00 AM", "In Progress", "Ahmedabad");
    add(_selectedDate, "Dr. Sharma Clinic", "02:00 PM", "Planned", "Gandhinagar");
    
    // Tomorrow's Visits
    final tomorrow = _selectedDate.add(const Duration(days: 1));
    add(tomorrow, "Sterling Labs", "11:30 AM", "Planned", "Surat");
    add(tomorrow, "Care Pharmacy", "04:00 PM", "Planned", "Surat");

    // Yesterday's Visits
    final yesterday = _selectedDate.subtract(const Duration(days: 1));
    add(yesterday, "Zydus Hospital", "09:00 AM", "Completed", "Ahmedabad");
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    // Lookup visits for selected date
    final currentVisits = _visits[_selectedDate] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Visits"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 1. Top Section: Date Strip
          Container(
            height: 100,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = _isSameDay(date, _selectedDate);
                final hasEvents = _visits.containsKey(date) && _visits[date]!.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5B5FC7) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date), // Mon, Tue
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Dot indicator
                        if (hasEvents)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : const Color(0xFF5B5FC7),
                            ),
                          )
                        else
                          const SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(height: 1, thickness: 1),

          // 2. Events Logic
          Expanded(
            child: currentVisits.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentVisits.length,
                    itemBuilder: (context, index) {
                      return _buildVisitCard(currentVisits[index]);
                    },
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
          Icon(Icons.event_note, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No Events",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(VisitModel visit) {
    // Status colors
    Color badgeBg;
    Color badgeText;

    switch (visit.status) {
      case "Planned":
        badgeBg = Colors.blue.shade50;
        badgeText = Colors.blue.shade700;
        break;
      case "In Progress":
        badgeBg = Colors.orange.shade50;
        badgeText = Colors.orange.shade800;
        break;
      case "Completed":
        badgeBg = Colors.green.shade50;
        badgeText = Colors.green.shade700;
        break;
      default:
        badgeBg = Colors.grey.shade100;
        badgeText = Colors.grey.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Time and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visit.time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    visit.status,
                    style: TextStyle(
                      color: badgeText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Account Name
            Text(
              visit.accountName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  visit.location,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VisitModel {
  final String accountName;
  final String time;
  final String status;
  final String location;

  VisitModel(this.accountName, this.time, this.status, this.location);
}
