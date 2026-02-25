import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class TestWiseScreen extends StatelessWidget {
  const TestWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Test Wise Sale",
      cards: [
        AnalysisCardData(title: "Top Test", value: "CBC", growth: "5000 Units", color: Colors.cyan),
        AnalysisCardData(title: "High Value", value: "MRI Brain", growth: "₹ 5L Sale", color: Colors.green),
        AnalysisCardData(title: "New Test", value: "Vitamin D", growth: "Growing", color: Colors.orange),
        AnalysisCardData(title: "Decline", value: "X-Ray", growth: "-2%", color: Colors.red),
      ],
      tableColumns: const ["Test Name", "Category", "Units Sold", "Avg Price", "Total Value"],
      tableRows: const [
        ["CBC", "Pathology", "5000", "₹ 300", "₹ 15,00,000"],
        ["MRI Brain", "Radiology", "100", "₹ 5000", "₹ 5,00,000"],
        ["Vitamin D", "Pathology", "800", "₹ 1000", "₹ 8,00,000"],
        ["Lipid Profile", "Pathology", "1200", "₹ 500", "₹ 6,00,000"],
      ],
    );
  }
}