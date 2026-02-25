import 'package:flutter/material.dart';
import 'msl_screen.dart';

class MslPerformanceScreen extends StatelessWidget {
  const MslPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MslBaseScreen(
      title: "MSL Performance",
      cards: [
        MslCardData(title: "Avg. Visits / Day", value: "4.5", growth: "+0.2 vs last month", color: Colors.indigo),
        MslCardData(title: "KOL Engagements", value: "120", growth: "High Impact", color: Colors.green),
      ],
      tableColumns: ["MSL Name", "Avg. Visits/Day", "KOL Engagements", "Avg. Score", "Reports Submitted"],
      tableRows: [
        ["Dr. Anjali Sharma", "4.8", "15", "4.9", "100%"],
        ["Dr. Vikram Singh", "4.2", "12", "4.7", "95%"],
        ["Dr. Priya Patel", "4.5", "10", "4.8", "99%"],
        ["Dr. Rohan Gupta", "4.6", "14", "4.9", "98%"],
      ],
    );
  }
}