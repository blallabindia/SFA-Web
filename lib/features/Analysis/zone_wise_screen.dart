import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class ZoneWiseScreen extends StatelessWidget {
  const ZoneWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Zone Wise Sale",
      cards: [
        AnalysisCardData(title: "Best Zone", value: "West", growth: "105% Ach", color: Colors.deepPurple),
        AnalysisCardData(title: "Total Zones", value: "4", growth: "All Active", color: Colors.blue),
        AnalysisCardData(title: "Avg Zone Sale", value: "₹ 12.5L", growth: "+5%", color: Colors.orange),
        AnalysisCardData(title: "Lagging Zone", value: "East", growth: "75% Ach", color: Colors.red),
      ],
      tableColumns: const ["Zone Name", "Manager", "Target", "Sale", "Ach %"],
      tableRows: const [
        ["North", "Ramesh", "₹ 15,00,000", "₹ 14,00,000", "93%"],
        ["South", "Suresh", "₹ 12,00,000", "₹ 11,50,000", "95%"],
        ["East", "Mahesh", "₹ 10,00,000", "₹ 7,50,000", "75%"],
        ["West", "Dinesh", "₹ 18,00,000", "₹ 19,00,000", "105%"],
      ],
    );
  }
}