import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/theme/app_theme.dart';

/// Wrapper that provides consistent blue background across all screens
class BlueScaffold extends StatelessWidget {
  const BlueScaffold({
    super.key,
    required this.child,
    this.navigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget child;
  final ObstructingPreferredSizeWidget? navigationBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: navigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      child: child,
    );
  }
}
