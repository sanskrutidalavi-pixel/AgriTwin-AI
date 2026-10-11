import 'package:flutter/material.dart';
import '../models/risk_level.dart';

/// Semantic pill badge displaying risk levels (Low, Medium, High) with theme colors
class RiskBadge extends StatelessWidget {
  final RiskLevel riskLevel;
  final String? customLabel;
  final bool showIcon;
  final bool isCompact;

  const RiskBadge({
    super.key,
    required this.riskLevel,
    this.customLabel,
    this.showIcon = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = customLabel ?? riskLevel.displayName;
    final color = riskLevel.color;
    final bgColor = riskLevel.backgroundColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8.0 : 10.0,
        vertical: isCompact ? 3.0 : 5.0,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              riskLevel.icon,
              size: isCompact ? 12 : 14,
              color: color,
            ),
            SizedBox(width: isCompact ? 4 : 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
