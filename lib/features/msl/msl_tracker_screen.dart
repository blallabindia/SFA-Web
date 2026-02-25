import 'package:flutter/material.dart';
import '../analysis/analysis_screen.dart';

class MslTrackerScreen extends StatelessWidget {
  const MslTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "MSL Tracker",
      cards: [
        AnalysisCardData(title: "Total MSL Doctors", value: "150", growth: "0% Change", color: Colors.purple),
        AnalysisCardData(title: "Met > 2 Times", value: "120", growth: "+5% vs Last Month", color: Colors.green),
        AnalysisCardData(title: "Met 1 Time", value: "20", growth: "-2% vs Last Month", color: Colors.orange),
        AnalysisCardData(title: "Not Met", value: "10", growth: "+1% vs Last Month", color: Colors.red),
      ],
      tableColumns: const ["Doctor Name", "Specialty", "Class", "Visits Planned", "Visits Actual"],
      tableRows: const [
        ["Dr. Sharma", "Cardio", "A", "4", "4"],
        ["Dr. Verma", "Ortho", "B", "2", "1"],
        ["Dr. Gupta", "General", "A", "4", "3"],
        ["Dr. Iyer", "Neuro", "A", "4", "4"],
      ],
    );
  }
}