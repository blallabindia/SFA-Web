import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class TargetAchievementScreen extends StatelessWidget {
  const TargetAchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Target & Achievement",
      cards: [
        AnalysisCardData(title: "Total Target", value: "₹ 50,00,000", growth: "+10% vs Last Month", color: Colors.blue),
        AnalysisCardData(title: "Total Achievement", value: "₹ 42,50,000", growth: "+12% vs Last Month", color: Colors.green),
        AnalysisCardData(title: "Achievement %", value: "85%", growth: "+2% vs Last Month", color: Colors.orange),
        AnalysisCardData(title: "Pending", value: "₹ 7,50,000", growth: "-5% vs Last Month", color: Colors.red),
      ],
      tableColumns: const ["Zone", "Sales Person", "Target", "Achievement", "%"],
      tableRows: const [
        ["North", "Raj Kumar", "10,00,000", "9,50,000", "95%"],
        ["South", "Amit Singh", "12,00,000", "10,00,000", "83%"],
        ["East", "Karan Mehta", "8,00,000", "6,00,000", "75%"],
        ["West", "Sumit Patel", "20,00,000", "17,00,000", "85%"],
      ],
    );
  }
}