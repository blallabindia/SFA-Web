import 'package:flutter/material.dart';
import 'msl_screen.dart';

class MslTargetAchievementScreen extends StatelessWidget {
  const MslTargetAchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MslBaseScreen(
      title: "MSL Target vs Achievement",
      cards: [
        MslCardData(title: "Engagement Target", value: "500", growth: "This Quarter", color: Colors.blue),
        MslCardData(title: "Engagement Achieved", value: "480", growth: "+10% vs last Q", color: Colors.green),
        MslCardData(title: "Achievement %", value: "96%", growth: "On Track", color: Colors.orange),
        MslCardData(title: "Pending", value: "20", growth: "To be covered", color: Colors.red),
      ],
      tableColumns: ["MSL Name", "Target (Engagements)", "Achieved", "Achievement %"],
      tableRows: [
        ["Dr. Anjali Sharma", "120", "118", "98.3%"],
        ["Dr. Vikram Singh", "110", "105", "95.4%"],
        ["Dr. Priya Patel", "100", "95", "95.0%"],
        ["Dr. Rohan Gupta", "120", "115", "95.8%"],
      ],
    );
  }
}