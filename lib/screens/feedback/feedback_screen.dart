import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../l10n/app_localizations.dart';
import '../main_navigation_screen.dart';

/// Screen allowing farmers to provide actionable feedback on the AI recommendations
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _selectedRating = 5;
  final Set<String> _selectedChips = {
    'Price Prediction',
    'Buyer Matching',
    'Logistics',
  };
  final TextEditingController _textController = TextEditingController();
  bool _submitted = false;

  final List<String> _chipOptions = const [
    'Price Prediction',
    'Buyer Matching',
    'Logistics',
    'Storage Advice',
    'Profit Tracking',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    setState(() {
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Farmer Feedback')),
        leading: _submitted
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
        automaticallyImplyLeading: !_submitted,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _submitted ? _buildThankYouView() : _buildFeedbackForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 84.0),
      children: [
        // Star Rating Card
        AppCard(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.tr('How useful was the AI recommendation?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  final isFilled = starNum <= _selectedRating;

                  return IconButton(
                    iconSize: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    icon: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isFilled ? const Color(0xFFFFB300) : AppColors.border,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = starNum;
                      });
                    },
                    tooltip: '$starNum Stars',
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$_selectedRating / 5',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Selectable Chips Card
        AppCard(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.tr('What did you like?'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _chipOptions.map((chipText) {
                  final isSelected = _selectedChips.contains(chipText);

                  return FilterChip(
                    label: Text(AppLocalizations.tr(chipText)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChips.add(chipText);
                        } else {
                          _selectedChips.remove(chipText);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryContainer,
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Text Input Field Card
        AppCard(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.tr('Additional feedback (optional)'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: AppLocalizations.tr('Share your suggestions to help local farmers...'),
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Submit Button
        PrimaryButton(
          label: AppLocalizations.tr('Submit Feedback'),
          icon: Icons.check_circle_rounded,
          onPressed: _submitFeedback,
        ),
      ],
    );
  }

  Widget _buildThankYouView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.positiveLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.positive, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                color: AppColors.positive,
                size: 54,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.tr('Thank You!'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.tr('Your feedback helps improve AgriTwin AI for the entire farmer collective.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: AppLocalizations.tr('Back to Dashboard'),
            icon: Icons.dashboard_rounded,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const MainNavigationScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
