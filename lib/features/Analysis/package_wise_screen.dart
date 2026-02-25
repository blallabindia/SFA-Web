import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class PackageWiseScreen extends StatelessWidget {
  const PackageWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Package Wise Sale",
      cards: [
        AnalysisCardData(title: "Best Package", value: "Full Body", growth: "200 Sold", color: Colors.teal),
        AnalysisCardData(title: "Revenue", value: "₹ 10,00,000", growth: "+10%", color: Colors.green),
        AnalysisCardData(title: "Avg Ticket", value: "₹ 5,000", growth: "Stable", color: Colors.blue),
        AnalysisCardData(title: "Low Moving", value: "Senior Cit.", growth: "10 Sold", color: Colors.red),
      ],
      tableColumns: const ["Package Name", "Includes", "Price", "Units", "Revenue"],
      tableRows: const [
        ["Full Body Checkup", "70 Tests", "₹ 5,000", "200", "₹ 10,00,000"],
        ["Diabetes Care", "HbA1c + Sugar", "₹ 1,500", "150", "₹ 2,25,000"],
        ["Heart Health", "Lipid + ECG", "₹ 2,500", "100", "₹ 2,50,000"],
        ["Senior Citizen", "Complete", "₹ 8,000", "10", "₹ 80,000"],
      ],
    );
  }
}