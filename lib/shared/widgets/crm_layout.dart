import 'package:flutter/material.dart';
import 'package:sfa_ui_flutter/features/msl/msl_tracker_screen.dart';
import 'app_sidebar.dart';
import 'app_topbar.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/leads/lead_screen.dart';
import '../../features/clients/client_screen.dart';
import '../../features/opportunities/opportunity_screen.dart';
import '../../features/visits/today_plan_screen.dart';
import '../../features/dcr/dcr_screen.dart';
import '../../features/dcr/claim_list.dart';
import '../../features/tasks/task_screen.dart';
import '../../features/analysis/analysis_screen.dart';
import '../../features/msl/msl_screen.dart';

class CRMLayout extends StatefulWidget {
  const CRMLayout({super.key});

  @override
  State<CRMLayout> createState() => _CRMLayoutState();
}

class _CRMLayoutState extends State<CRMLayout> {
  String selectedMenu = "Dashboard";

  Widget _getScreen() {
    switch (selectedMenu) {
      case "Leads":
        return const LeadContent();

      case "Clients":
        return const ClientContent();
      case "Opportunities":
        return const OpportunityContent();
      case "Visits":
        return const TodayPlanScreen();
      case "DCR":
        return const DcrScreen(completedVisits: []);
      case "Claims":
        return const ClaimListScreen();
      case "Tasks":
        return const TaskScreen();
      case "Target & Achievement":
        return const TargetAchievementScreen();
      case "MSL Tracker":
        return const MslTrackerScreen();
      case "Client Wise Sale":
        return const ClientWiseScreen();
      case "Doctor Wise Sale":
        return const DoctorWiseScreen();
      case "Segment Wise Sale":
        return const SegmentWiseScreen();
      case "Zone Wise Sale":
        return const ZoneWiseScreen();
      case "Test Wise Sale":
        return const TestWiseScreen();
      case "Package Wise Sale":
        return const PackageWiseScreen();
      case "MSL List":
        return const MslListScreen();
      case "MSL Mapping":
        return const MslMappingScreen();
      case "MSL Compliance":
        return const MslComplianceScreen();
      case "MSL Performance":
        return const MslPerformanceScreen();
      case "MSL Target vs Achievement":
        return const MslTargetAchievementScreen();
      case "Approvals":
        return const Center(child: Text("Approvals Screen"));
      case "Masters":
        return const Center(child: Text("Masters Screen"));
      default:
        return const DashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            AppSidebar(
              selectedMenu: selectedMenu,
              onMenuTap: (menu) {
                setState(() {
                  selectedMenu = menu;
                });
              },
            ),
            Expanded(
              child: Column(
                children: [
                  const AppTopbar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _getScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("SFA - UI")),
        drawer: Drawer(
          child: AppSidebar(
            selectedMenu: selectedMenu,
            onMenuTap: (menu) {
              setState(() {
                selectedMenu = menu;
              });
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(padding: const EdgeInsets.all(16), child: _getScreen()),
      );
    }
  }
}
