import 'package:flutter/material.dart';

class AppSidebar extends StatefulWidget {
  final String selectedMenu;
  final Function(String) onMenuTap;

  const AppSidebar({
    super.key,
    required this.selectedMenu,
    required this.onMenuTap,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isAnalysisExpanded = false;
  bool _isMslExpanded = false;

  @override
  void didUpdateWidget(covariant AppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isMslSubmenu(widget.selectedMenu)) {
      _isMslExpanded = true;
    }
    if (_isAnalysisSubmenu(widget.selectedMenu)) {
      _isAnalysisExpanded = true;
    }
  }

  bool _isAnalysisSubmenu(String menu) {
    const submenus = [
      "Target & Achievement",
      "MSL Tracker",
      "Client Wise Sale",
      "Doctor Wise Sale",
      "Segment Wise Sale",
      "Zone Wise Sale",
      "Test Wise Sale",
      "Package Wise Sale"
    ];
    return submenus.contains(menu);
  }

  bool _isMslSubmenu(String menu) {
    const submenus = [
      "MSL List",
      "MSL Mapping",
      "MSL Compliance",
      "MSL Performance",
      "MSL Target vs Achievement"
    ];
    return submenus.contains(menu);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1565C0),
      child: Column(
        children: [

          /// Header
          const SizedBox(height: 40),
          const Text(
            "SFA - UI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          /// Scrollable Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _menuItem(Icons.dashboard, "Dashboard"),
                _menuItem(Icons.person, "Leads"),
                _menuItem(Icons.people, "Clients"),
                _menuItem(Icons.work, "Opportunities"),
                _menuItem(Icons.calendar_today, "Visits"),
                _mslMenu(),
                _analysisMenu(),
                _menuItem(Icons.receipt_long, "DCR"),
                _menuItem(Icons.list_alt, "Claims"),
                _menuItem(Icons.task, "Tasks"),
                _menuItem(Icons.approval, "Approvals"),
                _menuItem(Icons.settings, "Masters"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.analytics, color: Colors.white),
          title: const Text(
            "Analysis",
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(
            _isAnalysisExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              _isAnalysisExpanded = !_isAnalysisExpanded;
            });
          },
        ),
        if (_isAnalysisExpanded)
          Container(
            color: Colors.black12,
            child: Column(
              children: [
                _submenuItem("Target & Achievement"),
                _submenuItem("MSL Tracker"),
                _submenuItem("Client Wise Sale"),
                _submenuItem("Doctor Wise Sale"),
                _submenuItem("Segment Wise Sale"),
                _submenuItem("Zone Wise Sale"),
                _submenuItem("Test Wise Sale"),
                _submenuItem("Package Wise Sale"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _mslMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.inventory, color: Colors.white),
          title: const Text(
            "MSL",
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(
            _isMslExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              _isMslExpanded = !_isMslExpanded;
            });
          },
        ),
        if (_isMslExpanded)
          Container(
            color: Colors.black12,
            child: Column(
              children: [
                _submenuItem("MSL List"),
                _submenuItem("MSL Mapping"),
                _submenuItem("MSL Compliance"),
                _submenuItem("MSL Performance"),
                _submenuItem("MSL Target vs Achievement"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _submenuItem(String title) {
    return _menuItem(Icons.circle, title, isSubmenu: true);
  }

  Widget _menuItem(IconData icon, String title, {bool isSubmenu = false}) {
    final bool isActive = widget.selectedMenu == title;

    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: isSubmenu ? 10 : 24,
      ),
      contentPadding:
          EdgeInsets.only(left: isSubmenu ? 32 : 16, right: 16),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSubmenu ? 14 : 16,
        ),
      ),
      tileColor:
          isActive ? Colors.white.withOpacity(0.2) : null,
      onTap: () => widget.onMenuTap(title),
    );
  }
}