import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/theme/app_theme.dart';

const _gearTypes = ['rod', 'reel', 'lure', 'line', 'hook', 'other'];

class GearFormScreen extends StatefulWidget {
  const GearFormScreen({super.key, this.existingGear});

  final GearData? existingGear;

  @override
  State<GearFormScreen> createState() => _GearFormScreenState();
}

class _GearFormScreenState extends State<GearFormScreen> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = _gearTypes.first;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingGear != null) {
      final g = widget.existingGear!;
      _nameController.text = g.name;
      _type = g.type;
      _brandController.text = g.brand ?? '';
      _notesController.text = g.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Please enter a name');
      return;
    }

    setState(() => _saving = true);
    final db = DatabaseProvider.of(context);
    final now = DateTime.now();

    try {
      if (widget.existingGear != null) {
        final updated = GearData(
          id: widget.existingGear!.id,
          name: name,
          type: _type,
          brand: _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          createdAt: widget.existingGear!.createdAt,
        );
        await db.updateGear(updated);
      } else {
        await db.insertGear(GearCompanion.insert(
          name: name,
          type: _type,
          brand: _brandController.text.trim().isEmpty
              ? const Value.absent()
              : Value(_brandController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? const Value.absent()
              : Value(_notesController.text.trim()),
          createdAt: now,
        ));
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showError(String msg) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
           transitionBetweenRoutes: false,
        automaticBackgroundVisibility: false,
        backgroundColor: AppColors.barBackground,
        middle: Text(widget.existingGear != null ? 'Edit Gear' : 'Add Gear'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : _save,
          child: _saving
              ? const CupertinoActivityIndicator()
              : const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              placeholder: 'Name',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _buildTypePicker(),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _brandController,
              placeholder: 'Brand (optional)',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              placeholder: 'Notes (optional)',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      maxLines: maxLines,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      placeholderStyle: const TextStyle(color: AppColors.textSecondary),
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }

  Widget _buildTypePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Type',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoSlidingSegmentedControl<String>(
            groupValue: _type,
            children: {
              for (final t in _gearTypes) t: _segmentChild(t),
            },
            onValueChanged: (v) => setState(() => _type = v ?? _gearTypes.first),
          ),
        ],
      ),
    );
  }

  Widget _segmentChild(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Text(
        label.substring(0, 1).toUpperCase() + label.substring(1),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
    );
  }
}
