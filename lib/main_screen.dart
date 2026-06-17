import 'package:expense_tracker/budget_screen.dart';
import 'package:expense_tracker/dashboard_screen.dart';
import 'package:expense_tracker/reports_screen.dart';
import 'package:expense_tracker/settings_screen.dart';
import 'package:expense_tracker/transaction_list_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget?> _tabCache = List<Widget?>.filled(5, null, growable: false);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTab(int index) {
    final cached = _tabCache[index];
    if (cached != null) {
      return cached;
    }

    final widget = switch (index) {
      0 => const DashboardScreen(),
      1 => const TransactionListScreen(),
      2 => const BudgetScreen(),
      3 => const ReportsScreen(),
      4 => const SettingsScreen(),
      _ => const SizedBox.shrink(),
    };
    _tabCache[index] = widget;
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Use NavigationRail for wider screens (tablets, desktops)
      if (constraints.maxWidth >= 600) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.all,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                  NavigationRailDestination(icon: Icon(Icons.swap_horiz_outlined), selectedIcon: Icon(Icons.swap_horiz), label: Text('Transactions')),
                  NavigationRailDestination(icon: Icon(Icons.pie_chart_outline), selectedIcon: Icon(Icons.pie_chart), label: Text('Budgets')),
                  NavigationRailDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: Text('Reports')),
                  NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: List.generate(_tabCache.length, (index) {
                    final isActive = index == _selectedIndex;
                    final child = isActive || _tabCache[index] != null ? _buildTab(index) : const SizedBox.shrink();
                    return Offstage(
                      offstage: !isActive,
                      child: TickerMode(
                        enabled: isActive,
                        child: child,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }

      // Use BottomNavigationBar for narrower screens (phones)
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: List.generate(_tabCache.length, (index) {
            final isActive = index == _selectedIndex;
            final child = isActive || _tabCache[index] != null ? _buildTab(index) : const SizedBox.shrink();
            return Offstage(
              offstage: !isActive,
              child: TickerMode(
                enabled: isActive,
                child: child,
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_outlined),
              activeIcon: Icon(Icons.swap_horiz),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              activeIcon: Icon(Icons.pie_chart),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
