import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';

class CatchFormScreen extends StatefulWidget {
  const CatchFormScreen({super.key, this.existingCatch});

  final Catche? existingCatch;

  @override
  State<CatchFormScreen> createState() => _CatchFormScreenState();
}

class _CatchFormScreenState extends State<CatchFormScreen> {
  final _speciesController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _date = DateTime.now();
  int? _selectedGearId;
  List<GearData> _gearList = [];
  bool _loading = true;
  bool _loadStarted = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingCatch != null) {
      final c = widget.existingCatch!;
      _speciesController.text = c.species;
      _weightController.text = c.weightKg.toString();
      _lengthController.text = c.lengthCm?.toString() ?? '';
      _notesController.text = c.notes ?? '';
      _locationController.text = c.locationName ?? '';
      _date = c.date;
      _selectedGearId = c.gearId;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadStarted) {
      _loadStarted = true;
      _loadGear();
    }
  }

  Future<void> _loadGear() async {
    final db = DatabaseProvider.of(context);
    final list = await db.allGear();
    if (mounted) {
      setState(() {
        _gearList = list;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _speciesController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final species = _speciesController.text.trim();
    if (species.isEmpty) {
      _showError('Species is required');
      return;
    }
    final weightStr = _weightController.text.trim();
    final weight = double.tryParse(weightStr);
    if (weight == null || weight <= 0) {
      _showError('Enter a valid weight in kg');
      return;
    }
    final length = double.tryParse(_lengthController.text.trim());

    setState(() => _saving = true);
    final db = DatabaseProvider.of(context);
    final now = DateTime.now();

    try {
      if (widget.existingCatch != null) {
        final updated = Catche(
          id: widget.existingCatch!.id,
          species: species,
          weightKg: weight,
          lengthCm: length,
          date: _date,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          locationName: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          gearId: _selectedGearId,
          createdAt: widget.existingCatch!.createdAt,
        );
        await db.updateCatch(updated);
      } else {
        await db.insertCatch(CatchesCompanion.insert(
          species: species,
          weightKg: weight,
          lengthCm: length != null ? Value(length) : const Value.absent(),
          date: _date,
          notes: _notesController.text.trim().isEmpty
              ? const Value.absent()
              : Value(_notesController.text.trim()),
          locationName: _locationController.text.trim().isEmpty
              ? const Value.absent()
              : Value(_locationController.text.trim()),
          gearId: _selectedGearId != null
              ? Value(_selectedGearId!)
              : const Value.absent(),
          createdAt: now,
        ));
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) _showError('Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
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

  Future<void> _pickDate() async {
    final picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.barBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel', style: TextStyle(color: AppColors.accent)),
                    ),
                    const Text('Select date', style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(ctx).pop(_date),
                      child: Text('Done', style: TextStyle(color: AppColors.accent)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _date,
                  onDateTimeChanged: (d) => _date = d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCatch != null;

    return BlueScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: AppColors.barBackground,
        border: null,
        middle: Text(isEdit ? 'Edit catch' : 'Log a catch'),
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
              : Text('Save', style: TextStyle(
                  color: _saving ? AppColors.textSecondary : AppColors.accent,
                  fontWeight: FontWeight.w600,
                )),
        ),
      ),
      child: _loading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('What did you catch?'),
                  _card([
                    _inputRow(
                      label: 'Species / fish type',
                      controller: _speciesController,
                      hint: 'e.g. Pike, Perch, Bream',
                      keyboardType: TextInputType.text,
                    ),
                    _divider(),
                    _inputRow(
                      label: 'Weight',
                      controller: _weightController,
                      hint: 'kg',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    _divider(),
                    _inputRow(
                      label: 'Length',
                      controller: _lengthController,
                      hint: 'cm (optional)',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle('When & where?'),
                  _card([
                    _dateRow(),
                    _divider(),
                    _inputRow(
                      label: 'Location',
                      controller: _locationController,
                      hint: 'Lake, river, spot name',
                      keyboardType: TextInputType.text,
                    ),
                  ]),
                  if (_gearList.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _sectionTitle('Gear used'),
                    _gearCard(),
                  ],
                  const SizedBox(height: 24),
                  _sectionTitle('Notes'),
                  _card([
                    CupertinoTextField(
                      controller: _notesController,
                      placeholder: 'Conditions, lure, technique…',
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(),
                      placeholderStyle: TextStyle(color: AppColors.textSecondary),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 0.5,
      color: AppColors.textSecondary.withValues(alpha: 0.2),
    );
  }

  Widget _inputRow({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              placeholder: hint,
              keyboardType: keyboardType,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              placeholderStyle: const TextStyle(color: AppColors.textSecondary),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateRow() {
    final dateStr = '${_date.day}.${_date.month.toString().padLeft(2, '0')}.${_date.year}';
    return GestureDetector(
      onTap: _pickDate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Text(
              'Date',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                dateStr,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(CupertinoIcons.calendar, color: AppColors.accent, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _gearCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _gearTile('No gear', null),
          ..._gearList.map((g) => _gearTile('${g.name} · ${g.type}', g.id)),
        ],
      ),
    );
  }

  Widget _gearTile(String label, int? gearId) {
    final selected = _selectedGearId == gearId;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedGearId = gearId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withValues(alpha: 0.12)
              : const Color(0x00000000),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (selected)
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AppColors.accent,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
