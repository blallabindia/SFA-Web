import 'package:flutter/material.dart';
import '../../features/visits/today_plan_screen.dart';
import '../../features/leads/lead_screen.dart';
import '../../features/opportunities/opportunity_screen.dart';
import '../../features/tasks/task_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 5;
    if (width < 1100) crossAxisCount = 4;
    if (width < 800) crossAxisCount = 3;
    if (width < 600) crossAxisCount = 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _ActionTile(
          title: "Visit",
          icon: Icons.calendar_today,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodayPlanScreen()),
          ),
        ),
        _ActionTile(
          title: "Lead",
          icon: Icons.person_add,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LeadContent()),
          ),
        ),
        _ActionTile(
          title: "Opportunity",
          icon: Icons.trending_up,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OpportunityContent()),
          ),
        ),
        _ActionTile(
          title: "Task",
          icon: Icons.task_alt,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          ),
        ),
        _ActionTile(
          title: "Onboarding",
          icon: Icons.badge,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Onboarding')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1565C0);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHovering
                ? primary.withAlpha((0.1 * 255).round())
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering ? primary : Colors.grey.shade300,
              width: isHovering ? 1.5 : 1,
            ),
            boxShadow: isHovering
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    primary.withAlpha((0.2 * 255).round()),
                child: Icon(widget.icon, color: primary),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isHovering ? primary : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}