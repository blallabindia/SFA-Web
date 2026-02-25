import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class SegmentWiseScreen extends StatelessWidget {
  const SegmentWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Segment Wise Sale",
      cards: [
        AnalysisCardData(title: "Top Segment", value: "Cardiology", growth: "40% Share", color: Colors.pink),
        AnalysisCardData(title: "Growth Segment", value: "Neurology", growth: "+15% YOY", color: Colors.green),
        AnalysisCardData(title: "Decline Segment", value: "General", growth: "-5% YOY", color: Colors.red),
        AnalysisCardData(title: "New Segment", value: "Oncology", growth: "Started", color: Colors.blue),
      ],
      tableColumns: const ["Segment", "Contribution %", "Sale Value", "Target", "Ach %"],
      tableRows: const [
        ["Cardiology", "40%", "₹ 20,00,000", "₹ 22,00,000", "90%"],
        ["Orthopedics", "25%", "₹ 12,50,000", "₹ 15,00,000", "83%"],
        ["Neurology", "20%", "₹ 10,00,000", "₹ 10,00,000", "100%"],
        ["General", "15%", "₹ 7,50,000", "₹ 8,00,000", "93%"],
      ],
    );
  }
}