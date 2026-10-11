import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/primary_button.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import '../scenario_simulation/scenario_simulation_screen.dart';

/// Screen presenting predicted price curves, demand stats, and market net-profit comparisons
class MarketAnalysisScreen extends StatelessWidget {
  const MarketAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const marketComparisons = MockData.marketComparisons;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Market Analysis & Mandis')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              children: [
                // Demand & Trend Overview Card
                AppCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.tr('Regional Demand'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.tr(MockData.marketDemandStatus),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.positive,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.tr('Consistently active buyers'),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 1,
                        color: AppColors.divider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.tr('Expected Demand'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.tr(MockData.expectedDemandIncrease),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.tr('Next 14-day projection'),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Price Trend Visualization Card
                AppCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.tr('Predicted Price Trend'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '₹ / Quintal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Custom Chart Canvas
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _PriceTrendChartPainter(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Price Legend Row
                      Row(
                        children: [
                          _PriceChip(label: AppLocalizations.tr('Today'), price: '₹2,800'),
                          _PriceChip(label: AppLocalizations.tr('3 Days'), price: '₹3,100'),
                          _PriceChip(label: AppLocalizations.tr('7 Days'), price: '₹3,250'),
                          _PriceChip(label: AppLocalizations.tr('15 Days'), price: '₹3,400'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Market Comparison Header
                SectionHeader(
                  title: AppLocalizations.tr('Mandi Net Profit Comparison'),
                  subtitle: AppLocalizations.tr('Calculated after deducting logistics & transit spoilage'),
                ),
                const SizedBox(height: 6),

                // Market Cards
                ...marketComparisons.map((market) {
                  final isRecommended = market.isAiRecommended;

                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(14.0),
                    borderColor: isRecommended
                        ? AppColors.primary
                        : AppColors.border,
                    backgroundColor: isRecommended
                        ? AppColors.primaryContainer.withValues(alpha: 0.3)
                        : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.tr(market.name),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isRecommended) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.stars_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.tr('AI Recommended'),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (market.distanceInfo.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.tr(market.distanceInfo),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // 4 Metrics in Row
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isRecommended
                                ? Colors.white
                                : AppColors.surfaceVariant.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _MetricCol(
                                label: AppLocalizations.tr('Mandi Price'),
                                value: '₹${market.grossPricePerQuintal.toInt()}',
                                color: AppColors.textPrimary,
                              ),
                              _MetricCol(
                                label: AppLocalizations.tr('Transport'),
                                value: '-₹${market.transportCostPerQuintal.toInt()}',
                                color: AppColors.warning,
                              ),
                              _MetricCol(
                                label: AppLocalizations.tr('Spoilage'),
                                value: '-₹${market.spoilageCostPerQuintal.toInt()}',
                                color: AppColors.urgent,
                              ),
                              _MetricCol(
                                label: AppLocalizations.tr('Net Profit'),
                                value: '₹${market.netProfitPerQuintal.toInt()}',
                                color: AppColors.positive,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Explanatory Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.tr('Insight: Market B offers the highest Net Profit (₹2,970/Qtl) because local aggregation cuts transport by ₹250 and reduces decay losses by 80%.'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CTA Button: Run Scenario Simulation
                PrimaryButton(
                  label: AppLocalizations.tr('Run Scenario Simulation'),
                  icon: Icons.query_stats_rounded,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ScenarioSimulationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final String price;

  const _PriceChip({
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MetricCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _MetricCol({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for smooth price trend curve
class _PriceTrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const prices = [2800.0, 3100.0, 3250.0, 3400.0];
    const minPrice = 2700.0;
    const maxPrice = 3500.0;

    final width = size.width;
    final height = size.height;
    final stepX = width / (prices.length - 1);

    final points = <Offset>[];
    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final normalized = (prices[i] - minPrice) / (maxPrice - minPrice);
      final y = height - (normalized * height * 0.8) - 15;
      points.add(Offset(x, y));
    }

    // Background Grid lines
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, height * 0.3), Offset(width, height * 0.3), gridPaint);
    canvas.drawLine(Offset(0, height * 0.7), Offset(width, height * 0.7), gridPaint);

    // Gradient fill under the curve
    final path = Path()..moveTo(points[0].dx, height);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, height);
    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.25),
          AppColors.primary.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Trend Line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots and Labels
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (final pt in points) {
      canvas.drawCircle(pt, 5, dotPaint);
      canvas.drawCircle(pt, 5, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
