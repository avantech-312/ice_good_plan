import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/screens/gear/gear_form_screen.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';

class GearListScreen extends StatelessWidget {
  const GearListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseProvider.of(context);
    return BlueScaffold(
      navigationBar: CupertinoNavigationBar(
           transitionBetweenRoutes: false,
        automaticBackgroundVisibility: false,
        backgroundColor: AppColors.barBackground,
        middle: const Text('Gear & Tools'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _openForm(context, null),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: StreamBuilder<List<GearData>>(
        stream: db.watchAllGear(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          final gearList = snapshot.data ?? [];
          if (gearList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bag,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No gear yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to add your first item',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton(
                    color: AppColors.accent,
                    onPressed: () => _openForm(context, null),
                    child: const Text(
                      'Add Gear',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            );
          }
          final byType = <String, List<GearData>>{};
          for (final g in gearList) {
            byType.putIfAbsent(g.type, () => []).add(g);
          }
          return ListView(
            children: [
              for (final entry in byType.entries)
                _GearSection(
                  type: entry.key,
                  items: entry.value,
                  onTap: (g) => _openForm(context, g),
                  onDelete: (g) => _deleteGear(context, db, g),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, GearData? existing) async {
    await Navigator.of(context).push<bool>(
      CupertinoPageRoute(
        builder: (ctx) => GearFormScreen(existingGear: existing),
      ),
    );
  }

  Future<void> _deleteGear(
      BuildContext context, AppDatabase db, GearData g) async {
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Gear'),
        content: Text('Delete ${g.name}?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await db.deleteGear(g);
    }
  }
}

class _GearSection extends StatelessWidget {
  const _GearSection({
    required this.type,
    required this.items,
    required this.onTap,
    required this.onDelete,
  });

  final String type;
  final List<GearData> items;
  final void Function(GearData) onTap;
  final void Function(GearData) onDelete;

  @override
  Widget build(BuildContext context) {
    final typeLabel =
        type.substring(0, 1).toUpperCase() + type.substring(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            typeLabel,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map(
          (g) => CupertinoContextMenu(
            actions: [
              CupertinoContextMenuAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onTap(g);
                },
                child: const Text('Edit'),
              ),
              CupertinoContextMenuAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete(g);
                },
                child: const Text('Delete'),
              ),
            ],
            child: GestureDetector(
              onTap: () => onTap(g),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (g.brand != null && g.brand!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              g.brand!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
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
        ),
      ],
    );
  }
}
