import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityModel(
        title: "New Lead Created",
        subtitle: "Dr. Sharma - Ahmedabad",
        time: "2 hrs ago",
        icon: Icons.person_add,
        color: Colors.blue,
      ),
      _ActivityModel(
        title: "Visit Completed",
        subtitle: "Apollo Hospital",
        time: "Today 11:30 AM",
        icon: Icons.calendar_today,
        color: Colors.green,
      ),
      _ActivityModel(
        title: "Price Request Approved",
        subtitle: "Corporate Package",
        time: "Yesterday",
        icon: Icons.approval,
        color: Colors.orange,
      ),
      _ActivityModel(
        title: "Task Overdue",
        subtitle: "Follow-up Call Pending",
        time: "1 day ago",
        icon: Icons.warning,
        color: Colors.red,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...activities.map((activity) => _ActivityTile(activity)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityModel activity;

  const _ActivityTile(this.activity);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity.color.withAlpha((0.1 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

class _ActivityModel {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  _ActivityModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}
