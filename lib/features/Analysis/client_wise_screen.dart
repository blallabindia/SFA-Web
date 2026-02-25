import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class ClientWiseScreen extends StatelessWidget {
  const ClientWiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisBaseScreen(
      title: "Client Wise Sale",
      cards: [
        AnalysisCardData(title: "Active Clients", value: "45", growth: "+2 New", color: Colors.blue),
        AnalysisCardData(title: "Top Client Sale", value: "₹ 5,00,000", growth: "Apollo Hospital", color: Colors.green),
        AnalysisCardData(title: "Avg Sale/Client", value: "₹ 50,000", growth: "+5%", color: Colors.orange),
        AnalysisCardData(title: "Zero Billing", value: "5", growth: "-1", color: Colors.red),
      ],
      tableColumns: const ["Client Name", "Type", "Total Sale", "Last Month Sale", "Growth"],
      tableRows: const [
        ["Apollo Hospital", "Hospital", "₹ 5,00,000", "₹ 4,50,000", "+11%"],
        ["City Diagnostics", "Lab", "₹ 2,00,000", "₹ 2,10,000", "-5%"],
        ["Max Healthcare", "Hospital", "₹ 3,50,000", "₹ 3,00,000", "+16%"],
        ["Dr. Lal PathLabs", "Lab", "₹ 1,50,000", "₹ 1,50,000", "0%"],
      ],
    );
  }
}