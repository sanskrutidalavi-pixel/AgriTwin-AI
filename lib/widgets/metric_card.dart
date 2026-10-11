import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';

enum MetricTrend {
  positive,
  negative,
  neutral;
}

/// Key performance and statistical metric card for dashboard & analytics
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final MetricTrend trend;
  final String? trendText;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.trend = MetricTrend.neutral,
    this.trendText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color trendColor;
    IconData? trendIcon;

    switch (trend) {
      case MetricTrend.positive:
        trendColor = AppColors.positive;
        trendIcon = Icons.trending_up_rounded;
        break;
      case MetricTrend.negative:
        trendColor = AppColors.urgent;
        trendIcon = Icons.trending_down_rounded;
        break;
      case MetricTrend.neutral:
        trendColor = AppColors.textSecondary;
        trendIcon = null;
        break;
    }

    return AppCard(
      elevation: 2,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          // Adjust layout for subtitle and trend text to prevent overflow
          if (subtitle != null || trendText != null) ...[
            const SizedBox(height: 6),
            // Trend icon and text on a single line
            if (trendText != null) ...[
              Row(
                children: [
                  if (trendIcon != null) ...[
                    Icon(trendIcon, size: 14, color: trendColor),
                    const SizedBox(width: 3),
                  ],
                  Flexible(
                    child: Text(
                      trendText!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trendColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            // Subtitle on its own line
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
