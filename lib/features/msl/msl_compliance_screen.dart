import 'package:flutter/material.dart';
import 'msl_screen.dart';

class MslComplianceScreen extends StatelessWidget {
  const MslComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MslBaseScreen(
      title: "MSL Compliance",
      cards: [
        MslCardData(title: "Total Visits Planned", value: "800", growth: "This Month", color: Colors.blue),
        MslCardData(title: "Compliant Visits", value: "750", growth: "+5%", color: Colors.green),
        MslCardData(title: "Compliance %", value: "93.75%", growth: "Above Target", color: Colors.teal),
        MslCardData(title: "Deviations", value: "50", growth: "Needs Attention", color: Colors.red),
      ],
      tableColumns: ["MSL Name", "Zone", "Planned Visits", "Actual Visits", "Compliance %"],
      tableRows: [
        ["Dr. Anjali Sharma", "North", "80", "78", "97.5%"],
        ["Dr. Vikram Singh", "West", "75", "70", "93.3%"],
        ["Dr. Priya Patel", "South", "60", "55", "91.6%"],
        ["Dr. Rohan Gupta", "East", "85", "82", "96.4%"],
      ],
    );
  }
}