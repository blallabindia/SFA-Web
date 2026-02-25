import 'package:flutter/material.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/quick_actions.dart';
import '../../shared/widgets/recent_activities.dart';
import '../visits/today_plan_screen.dart';
import '../tasks/task_screen.dart';
import '../opportunities/opportunity_screen.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 4;

    if (width < 600) {
      crossAxisCount = 1;
    } else if (width < 1000) {
      crossAxisCount = 2;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodayPlanScreen())),
                child: const DashboardCard(
                  title: "Planned Visits",
                  value: "12",
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskScreen())),
                child: const DashboardCard(
                  title: "Tasks Due",
                  value: "8",
                  icon: Icons.task_alt,
                  color: Colors.orange,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OpportunityContent())),
                child: const DashboardCard(
                  title: "Open Pipeline",
                  value: "₹ 2.5L",
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Center(child: Text('Approvals')))),
                child: const DashboardCard(
                  title: "Pending Approvals",
                  value: "5",
                  icon: Icons.approval,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const QuickActions(),

          const SizedBox(height: 30),

          const RecentActivities(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
