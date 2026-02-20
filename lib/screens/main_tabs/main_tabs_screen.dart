import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/screens/analytics/analytics_screen.dart';
import 'package:ice_good_plan/screens/catch_logger/catch_list_screen.dart';
import 'package:ice_good_plan/screens/gear/gear_list_screen.dart';
import 'package:ice_good_plan/screens/tips/tips_list_screen.dart';
import 'package:ice_good_plan/theme/app_theme.dart';

class MainTabsScreen extends StatelessWidget {
  const MainTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.barBackground,
        activeColor: AppColors.accent,
        inactiveColor: AppColors.textSecondary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Catches',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bag),
            label: 'Gear',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lightbulb),
            label: 'Tips',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const CatchListScreen();
          case 1:
            return const GearListScreen();
          case 2:
            return const AnalyticsScreen();
          case 3:
            return const TipsListScreen();
          default:
            return const CatchListScreen();
        }
      },
    );
  }
}
