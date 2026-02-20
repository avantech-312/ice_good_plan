import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/screens/main_tabs/main_tabs_screen.dart';
import 'package:ice_good_plan/screens/onboarding/onboarding_screen.dart';

class IceGoodPlanAppRoot extends StatefulWidget {
  const IceGoodPlanAppRoot({super.key});

  @override
  State<IceGoodPlanAppRoot> createState() => _IceGoodPlanAppRootState();
}

class _IceGoodPlanAppRootState extends State<IceGoodPlanAppRoot> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final complete = await isOnboardingComplete();
    if (mounted) {
      setState(() => _showOnboarding = !complete);
    }
  }

  void _onOnboardingComplete() {
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }
    return const MainTabsScreen();
  }
}
