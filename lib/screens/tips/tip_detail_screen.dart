import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';

class TipDetailScreen extends StatelessWidget {
  const TipDetailScreen({super.key, required this.tip});

  final Tip tip;

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'technique':
        return 'Technique';
      case 'bait':
        return 'Bait';
      case 'gear':
        return 'Gear';
      case 'safety':
        return 'Safety';
      default:
        return cat.substring(0, 1).toUpperCase() + cat.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlueScaffold(
      navigationBar: CupertinoNavigationBar(
           transitionBetweenRoutes: false,
        automaticBackgroundVisibility: false,
        backgroundColor: AppColors.barBackground,
        middle: Text(
          tip.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _categoryLabel(tip.category),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tip.body,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
