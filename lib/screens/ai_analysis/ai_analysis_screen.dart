import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../l10n/app_localizations.dart';
import '../ai_decision/ai_decision_screen.dart';

/// Simulated 2-3 second AI Digital Twin Analysis Screen
class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
  final List<String> _steps = const [
    'Market prices',
    'Historical trends',
    'Future price prediction',
    'Demand analysis',
    'Weather conditions',
    'Transport cost',
    'Storage availability',
    'Spoilage risk',
  ];

  int _currentStepIndex = 0;
  bool _isComplete = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnalysisSimulation();
  }

  void _startAnalysisSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) return;
      setState(() {
        if (_currentStepIndex < _steps.length) {
          _currentStepIndex++;
        } else {
          _isComplete = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDecision() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AiDecisionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _steps.isEmpty ? 1.0 : (_currentStepIndex / _steps.length).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('AI Analysis Engine')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card with Pulse / Status Indicator
                AppCard(
                  padding: const EdgeInsets.all(18.0),
                  backgroundColor: _isComplete
                      ? AppColors.primaryContainer.withValues(alpha: 0.6)
                      : Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isComplete
                              ? AppColors.primary
                              : AppColors.primaryContainer,
                        ),
                        child: Center(
                          child: _isComplete
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 32,
                                )
                              : const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _isComplete
                            ? AppLocalizations.tr('AI Analysis Complete')
                            : AppLocalizations.tr('Analyzing Produce & Market Data...'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _isComplete
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isComplete
                            ? AppLocalizations.tr('Digital twin calibrated with 87% prediction confidence')
                            : AppLocalizations.tr('Aggregating live APMC feeds, weather, & cold chain models'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      // Linear Progress Indicator
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Steps Checklist
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: ListView.separated(
                      itemCount: _steps.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: AppColors.divider,
                      ),
                      itemBuilder: (context, index) {
                        final stepName = _steps[index];
                        final isChecked = index < _currentStepIndex;
                        final isCurrent = index == _currentStepIndex && !_isComplete;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isChecked
                                      ? AppColors.positive
                                      : (isCurrent
                                          ? AppColors.primaryContainer
                                          : AppColors.surfaceVariant),
                                ),
                                child: Center(
                                  child: isChecked
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : (isCurrent
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textTertiary,
                                              ),
                                            )),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  AppLocalizations.tr(stepName),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isChecked
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isChecked
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              if (isChecked)
                                Text(
                                  AppLocalizations.tr('Verified'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.positive,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom Action Button
                if (_isComplete)
                  PrimaryButton(
                    label: AppLocalizations.tr('View AI Decision'),
                    icon: Icons.insights_rounded,
                    onPressed: _navigateToDecision,
                  )
                else
                  SecondaryButton(
                    label: AppLocalizations.tr('Analyzing with AgriTwin AI...'),
                    onPressed: () {
                      setState(() {
                        _currentStepIndex = _steps.length;
                        _isComplete = true;
                        _timer?.cancel();
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
