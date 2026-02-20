import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';
import 'package:ice_good_plan/screens/tips/tip_detail_screen.dart';

class TipsListScreen extends StatefulWidget {
  const TipsListScreen({super.key});

  @override
  State<TipsListScreen> createState() => _TipsListScreenState();
}

class _TipsListScreenState extends State<TipsListScreen> {
  List<Tip> _tips = [];
  bool _loading = true;
  bool _loadStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadStarted) {
      _loadStarted = true;
      _load();
    }
  }

  Future<void> _load() async {
    final db = DatabaseProvider.of(context);
    await db.seedTipsIfEmpty();
    final tips = await db.allTips();
    if (mounted) {
      setState(() {
        _tips = tips;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlueScaffold(
      navigationBar: CupertinoNavigationBar(
           transitionBetweenRoutes: false,
        automaticBackgroundVisibility: false,
        backgroundColor: AppColors.barBackground,
        middle: const Text('Tips'),
      ),
      child: _loading
          ? const Center(child: CupertinoActivityIndicator())
          : _groupByCategory(),
    );
  }

  Widget _groupByCategory() {
    final byCategory = <String, List<Tip>>{};
    for (final t in _tips) {
      byCategory.putIfAbsent(t.category, () => []).add(t);
    }
    final order = ['technique', 'bait', 'gear', 'safety', 'other'];
    return ListView(
      children: [
        for (final cat in order)
          if (byCategory.containsKey(cat))
            _TipSection(
              category: _categoryLabel(cat),
              tips: byCategory[cat]!,
              onTap: (t) => _openDetail(context, t),
            ),
      ],
    );
  }

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

  void _openDetail(BuildContext context, Tip tip) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (ctx) => TipDetailScreen(tip: tip),
      ),
    );
  }
}

class _TipSection extends StatelessWidget {
  const _TipSection({
    required this.category,
    required this.tips,
    required this.onTap,
  });

  final String category;
  final List<Tip> tips;
  final void Function(Tip) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            category,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...tips.map(
          (t) => GestureDetector(
            onTap: () => onTap(t),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.lightbulb,
                    color: AppColors.accent,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
