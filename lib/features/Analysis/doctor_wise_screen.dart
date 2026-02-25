import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class DoctorWiseScreen extends StatelessWidget {
  const DoctorWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Doctor Wise Sale",
      cards: [
        AnalysisCardData(title: "Prescribing Drs", value: "85", growth: "+5 New", color: Colors.indigo),
        AnalysisCardData(title: "Top Prescriber", value: "₹ 2,00,000", growth: "Dr. Sharma", color: Colors.green),
        AnalysisCardData(title: "Yield / Doctor", value: "₹ 15,000", growth: "+2%", color: Colors.teal),
        AnalysisCardData(title: "Dropped Drs", value: "3", growth: "+1", color: Colors.red),
      ],
      tableColumns: const ["Doctor Name", "Specialty", "Total Rx Value", "Support", "ROI"],
      tableRows: const [
        ["Dr. Sharma", "Cardio", "₹ 2,00,000", "₹ 10,000", "20x"],
        ["Dr. Verma", "Ortho", "₹ 1,50,000", "₹ 5,000", "30x"],
        ["Dr. Gupta", "General", "₹ 80,000", "₹ 2,000", "40x"],
        ["Dr. Singh", "Neuro", "₹ 1,20,000", "₹ 8,000", "15x"],
      ],
    );
  }
}