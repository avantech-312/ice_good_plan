import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/theme/app_theme.dart';
import 'package:ice_good_plan/widgets/blue_scaffold.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _totalCatches = 0;
  double _totalWeight = 0;
  List<({String species, int count})> _bySpecies = [];
  List<({int month, int year, int count})> _perMonth = [];
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
    final totalCatches = await db.totalCatchesCount();
    final totalWeight = await db.totalWeight();
    final bySpecies = await db.catchesBySpecies();
    final perMonth = await db.catchesPerMonth();
    if (mounted) {
      setState(() {
        _totalCatches = totalCatches;
        _totalWeight = totalWeight;
        _bySpecies = bySpecies;
        _perMonth = perMonth;
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
        middle: const Text('Analytics'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _loading ? null : () async {
            setState(() => _loading = true);
            await _load();
          },
          child: const Icon(CupertinoIcons.refresh),
        ),
      ),
      child: _loading
          ? const Center(child: CupertinoActivityIndicator())
          : CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: _load),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSummaryCards(),
                      const SizedBox(height: 24),
                      if (_bySpecies.isNotEmpty) _buildSpeciesChart(),
                      if (_bySpecies.isNotEmpty) const SizedBox(height: 24),
                      if (_perMonth.isNotEmpty) _buildMonthlyChart(),
                      if (_totalCatches == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.chart_bar,
                                  size: 64,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Log some catches to see analytics',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            'Catches',
            _totalCatches.toString(),
            CupertinoIcons.list_bullet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            'Total (kg)',
            _totalWeight.toStringAsFixed(1),
            CupertinoIcons.square_stack_3d_up,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesChart() {
    final maxCount = _bySpecies.isEmpty
        ? 1
        : _bySpecies.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catches by Species',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxCount.toDouble() + 1,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, m) => Text(
                      v.toInt().toString(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, m) {
                      final i = v.toInt();
                      if (i >= 0 && i < _bySpecies.length) {
                        final s = _bySpecies[i].species;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            s.length > 8 ? '${s.substring(0, 8)}…' : s,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(
                _bySpecies.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: _bySpecies[i].count.toDouble(),
                      color: AppColors.accent,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    final maxCount = _perMonth.isEmpty
        ? 1
        : _perMonth.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catches per Month',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxCount.toDouble() + 1,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, m) => Text(
                      v.toInt().toString(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, m) {
                      final i = v.toInt();
                      if (i >= 0 && i < _perMonth.length) {
                        final m = _perMonth[i];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${m.month}/${m.year.toString().substring(2)}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(
                _perMonth.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: _perMonth[i].count.toDouble(),
                      color: AppColors.accent,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
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

