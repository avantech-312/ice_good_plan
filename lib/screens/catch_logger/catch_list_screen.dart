import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/screens/catch_logger/catch_form_screen.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';

class CatchListScreen extends StatelessWidget {
  const CatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseProvider.of(context);
    return BlueScaffold(
      navigationBar: CupertinoNavigationBar(
           transitionBetweenRoutes: false,
        automaticBackgroundVisibility: false,
        backgroundColor: AppColors.barBackground,
        middle: const Text('Catches'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _openForm(context, null),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: StreamBuilder<List<Catche>>(
        stream: db.watchAllCatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          final catches = snapshot.data ?? [];
          if (catches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.list_bullet,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No catches yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to add your first catch',
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
                      'Add Catch',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {},
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final c = catches[index];
                    return _CatchTile(
                      catch_: c,
                      onTap: () => _openForm(context, c),
                      onDelete: () => _deleteCatch(context, db, c),
                    );
                  },
                  childCount: catches.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, Catche? existing) async {
    await Navigator.of(context).push<bool>(
      CupertinoPageRoute(
        builder: (ctx) => CatchFormScreen(existingCatch: existing),
      ),
    );
  }

  Future<void> _deleteCatch(
      BuildContext context, AppDatabase db, Catche c) async {
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Catch'),
        content: Text(
          'Delete ${c.species} (${c.weightKg} kg)?',
        ),
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
      await db.deleteCatch(c);
    }
  }
}

class _CatchTile extends StatelessWidget {
  const _CatchTile({
    required this.catch_,
    required this.onTap,
    required this.onDelete,
  });

  final Catche catch_;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${catch_.date.year}-${catch_.date.month.toString().padLeft(2, '0')}-${catch_.date.day.toString().padLeft(2, '0')}';
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context).pop();
            onTap();
          },
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          child: const Text('Delete'),
        ),
      ],
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      catch_.species,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${catch_.weightKg} kg'
                      '${catch_.lengthCm != null ? ' • ${catch_.lengthCm} cm' : ''}'
                      ' • $dateStr',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (catch_.locationName != null &&
                        catch_.locationName!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        catch_.locationName!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
    );
  }
}
