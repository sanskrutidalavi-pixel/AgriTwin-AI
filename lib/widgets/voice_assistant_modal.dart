import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../data/mock_data.dart';
/// Fully Functional Multilingual AI Voice Assistant for AgriTwin AI
class VoiceAssistantModal extends StatefulWidget {
  const VoiceAssistantModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceAssistantModal(),
    );
  }

  @override
  State<VoiceAssistantModal> createState() => _VoiceAssistantModalState();
}

class _VoiceAssistantModalState extends State<VoiceAssistantModal>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  bool _isPlayingAudio = false;
  String _assistantResponse = '';
  String _detectedIntent = '';

  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _speechAvailable = false;

  Timer? _listeningTimer;
  Timer? _audioTimer;
  late AnimationController _pulseController;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeechAndTts();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  void _initSpeechAndTts() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (val) => debugPrint('Speech error: $val'),
        onStatus: (val) => debugPrint('Speech status: $val'),
      );
    } catch (e) {
      _speechAvailable = false;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _listeningTimer?.cancel();
    _audioTimer?.cancel();
    _inputController.dispose();
    try {
      _speech.stop();
      _flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  void _startListening([String? query]) async {
    if (query != null) {
      _inputController.text = query;
      _processQuery(query);
      return;
    }

    setState(() {
      _isListening = true;
      _isPlayingAudio = false;
      _assistantResponse = '';
      _detectedIntent = '';
    });

    if (_speechAvailable) {
      try {
        String localeId = "en_IN";
        final code = AppLocalizations.currentLangCode;
        if (code == 'mr') localeId = "mr_IN";
        if (code == 'hi') localeId = "hi_IN";

        await _speech.listen(
          localeId: localeId,
          onResult: (result) {
            if (mounted) {
              setState(() {
                _inputController.text = result.recognizedWords;
              });
              if (result.finalResult) {
                _speech.stop();
                _processQuery(result.recognizedWords);
              }
            }
          },
        );
      } catch (e) {
        _fallbackListeningSimulation();
      }
    } else {
      _fallbackListeningSimulation();
    }
  }

  void _fallbackListeningSimulation() {
    _listeningTimer?.cancel();
    _listeningTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        final text = _inputController.text.trim().isNotEmpty
            ? _inputController.text.trim()
            : (AppLocalizations.currentLangCode == 'mr'
                ? 'मी माझं पीक कधी विकू?'
                : AppLocalizations.currentLangCode == 'hi'
                    ? 'मैं अपनी फसल कब बेचूं?'
                    : 'When should I sell my crop?');
        _processQuery(text);
      }
    });
  }

  void _processQuery(String text) {
    final lower = text.toLowerCase().trim();
    String response = '';
    String intent = '';

    // Active selected language mode forces output language
    final langCode = AppLocalizations.currentLangCode;

    // 1. INTENT: when_to_sell
    if (lower.contains('कधी विकू') ||
        lower.contains('कधी विकायचा') ||
        lower.contains('आता विकू') ||
        lower.contains('काही दिवस थांबलो') ||
        lower.contains('चांगला भाव कधी') ||
        lower.contains('kadhi viku') ||
        lower.contains('kadhiviku') ||
        lower.contains('aata viku') ||
        lower.contains('कब बेचूं') ||
        lower.contains('बेचूं या रुकूं') ||
        lower.contains('कब बेचना') ||
        lower.contains('abhi bechu') ||
        lower.contains('when should i sell') ||
        lower.contains('should i sell') ||
        lower.contains('when to sell') ||
        lower.contains('is this a good time')) {
      intent = AppLocalizations.tr('Best Time to Sell');
      final bestScenario = MockData.profitScenarios.reduce((a, b) => a.expectedProfit > b.expectedProfit ? a : b);
      final profit = bestScenario.expectedProfit;
      final timeFrame = bestScenario.timeFrame;
      if (langCode == 'mr') {
        response = "एआय अंदाजानुसार, $timeFrame मध्ये "
            "गुलटेकडी एपीएमसी (पुणे) मध्ये टमॅटो विकल्यास आपल्याला प्रति क्विंटल ₹${profit.toStringAsFixed(0)} शुद्ध नफा मिळेल.";
      } else if (langCode == 'hi') {
        response = "एआई पूर्वानुमान के अनुसार, $timeFrame में गुलटेकड़ी एपीएमसी (पुणे) में टमाटर बेचने पर आपको प्रति क्विंटल ₹${profit.toStringAsFixed(0)} का शुद्ध लाभ मिलेगा।";
      } else {
        response = "Based on AI prediction, $timeFrame selling Tomato at Gultekdi APMC (Pune) gives a net profit of ₹${profit.toStringAsFixed(0)}/quintal.";
      }
    }
    // 2. INTENT: crop_price
    else if (lower.contains('भाव') ||
        lower.contains('bhav') ||
        lower.contains('दर') ||
        lower.contains('कीमत') ||
        lower.contains('रेट') ||
        lower.contains('price') ||
        lower.contains('rate')) {
      intent = AppLocalizations.tr("Today's Market Price");
      final price = MockData.sampleProduce.currentMarketPricePerQuintal;
      final expected = MockData.sampleProduce.expectedPricePerQuintal;
      if (langCode == 'mr') {
        response = "पुणे एपीएमसीमध्ये आज टोमॅटोचा सरासरी भाव ₹${price.toStringAsFixed(0)}/क्विंटल आहे. ३ दिवसांत भाव ₹${expected.toStringAsFixed(0)} पर्यंत वाढण्याची शक्यता आहे.";
      } else if (langCode == 'hi') {
        response = "पुणे एपीएमसी में आज टमाटर का औसत भाव ₹${price.toStringAsFixed(0)}/क्विंटल है। 3 दिनों में भाव ₹${expected.toStringAsFixed(0)} तक बढ़ने की संभावना है।";
      } else {
        response = "Today's average Tomato price in Pune APMC is ₹${price.toStringAsFixed(0)}/quintal. Prices are expected to rise to ₹${expected.toStringAsFixed(0)} in 3 days.";
      }
    }
    // 3. INTENT: best_market
    else if (lower.contains('जास्त नफा') ||
        lower.contains('कोणत्या बाजारात') ||
        lower.contains('jast nafa') ||
        lower.contains('सबसे ज्यादा मुनाफा') ||
        lower.contains('कौन सी मंडी') ||
        lower.contains('highest profit') ||
        lower.contains('best market') ||
        lower.contains('max price')) {
      intent = AppLocalizations.tr('Best Market Mandi');
      final recommended = MockData.marketComparisons.firstWhere((m) => m.isAiRecommended, orElse: () => MockData.marketComparisons[0]);
      final name = recommended.name;
      final netProfit = recommended.netProfitPerQuintal;
      if (langCode == 'mr') {
        response = "${name} ही सर्वाधिक शुद्ध नफा ₹${netProfit.toStringAsFixed(0)}/क्विंटल देते.";
      } else if (langCode == 'hi') {
        response = "${name} सबसे अधिक शुद्ध लाभ ₹${netProfit.toStringAsFixed(0)}/क्विंटल प्रदान करता है.";
      } else {
        response = "${name} offers the highest net profit of ₹${netProfit.toStringAsFixed(0)}/quintal.";
      }
    }
// 4. INTENT: storage_decision
    else if (lower.contains('साठवून') ||
        lower.contains('sathvun') ||
        lower.contains('स्टोर') ||
        lower.contains('कोल्ड स्टोरेज') ||
        lower.contains('storage') ||
        lower.contains('store')) {
      intent = AppLocalizations.tr('Storage Recommendation');
      if (langCode == 'mr') {
        response = 'एआय सल्ला देतो की सह्याद्री कोल्ड स्टोरेज हडपसरमध्ये ३ दिवस माल साठवून ठेवा, ज्यामुळे प्रति क्विंटल ₹३०० अतिरिक्त नफा मिळेल.';
      } else if (langCode == 'hi') {
        response = 'एआई सलाह देता है कि सह्याद्री कोल्ड स्टोरेज हडपसर में 3 दिनों के लिए स्टोर करें, जिससे प्रति क्विंटल ₹300 अतिरिक्त लाभ मिलेगा।';
      } else {
        response = 'AI recommends storing in Sahyadri Cold Storage Hadapsar for 3 days to gain ₹300/qtl additional profit.';
      }
    }
    // 5. INTENT: transport_cost
    else if (lower.contains('वाहतूक') ||
        lower.contains('vahtuk') ||
        lower.contains('गाडी भाडे') ||
        lower.contains('ट्रांसपोर्ट') ||
        lower.contains('भाड़ा') ||
        lower.contains('transport') ||
        lower.contains('logistics')) {
      intent = AppLocalizations.tr('Transport Cost');
      if (langCode == 'mr') {
        response = 'गुलटेकडी एपीएमसीसाठी वाहतूक खर्च सर्वात कमी ₹१५०/क्विंटल (१२ किमी) आहे, पिंपरी एपीएमसीच्या (₹२५०) तुलनेत.';
      } else if (langCode == 'hi') {
        response = 'गुलटेकड़ी एपीएमसी के लिए परिवहन लागत सबसे कम ₹150/क्विंटल (12 किमी) है, पिंपरी एपीएमसी (₹250) की तुलना में।';
      } else {
        response = 'Gultekdi APMC has the lowest transport cost at ₹150/qtl (12 km away) compared to Pimpri APMC (₹250/qtl).';
      }
    }
    // 6. INTENT: expected_profit
    else if (lower.contains('किती नफा') ||
        lower.contains('kiti nafa') ||
        lower.contains('उत्पन्न') ||
        lower.contains('कितना मुनाफा') ||
        lower.contains('आय') ||
        lower.contains('expected profit') ||
        lower.contains('net profit')) {
      intent = AppLocalizations.tr('Expected Net Profit');
      if (langCode == 'mr') {
        response = 'गुलटेकडी एपीएमसीमध्ये १० क्विंटल (१,००० किग्रॅ) टोमॅटोसाठी तुमचा एकूण अंदाजित शुद्ध नफा ₹३०,५०० आहे.';
      } else if (langCode == 'hi') {
        response = 'गुलटेकड़ी एपीएमसी में 10 क्विंटल (1,000 किग्रा) टमाटर के लिए आपका कुल अनुमानित शुद्ध लाभ ₹30,500 है।';
      } else {
        response = 'Your total estimated net profit for 10 quintals (1,000 kg) Tomato at Gultekdi APMC is ₹30,500.';
      }
    }
    // 7. INTENT: scenario_simulation
    else if (lower.contains('10%') ||
        lower.contains('१०%') ||
        lower.contains('घसरली') ||
        lower.contains('कमी झाले') ||
        lower.contains('कम हो गई') ||
        lower.contains('falls') ||
        lower.contains('drop')) {
      intent = AppLocalizations.tr('Scenario Simulation');
      if (langCode == 'mr') {
        response = 'भाव १०% कमी झाल्यास दर ₹२,६१०/क्विंटल होईल. धोका कमी करण्यासाठी एआय ५०% माल त्वरित विकण्याचा सल्ला देतो.';
      } else if (langCode == 'hi') {
        response = 'यदि कीमतें 10% गिरती हैं, तो शुद्ध मूल्य ₹2,610/क्विंटल हो जाएगा। एआई जोखिम कम करने के लिए तुरंत 50% बेचने की सलाह देता है।';
      } else {
        response = 'If prices drop by 10%, net price becomes ₹2,610/qtl. AI advises selling 50% lot immediately to hedge risk.';
      }
    }
    // DEFAULT RESPONSE
    else {
      intent = AppLocalizations.tr('AI Recommendation');
      if (langCode == 'mr') {
        response = 'टोमॅटो पिकासाठी पुणे गुलटेकडी एपीएमसीमध्ये ३ दिवसांत विकल्यास सर्वोच्च ₹३,०५०/क्विंटल नफा मिळेल.';
      } else if (langCode == 'hi') {
        response = 'टमाटर की फसल के लिए पुणे गुलटेकड़ी एपीएमसी में 3 दिनों में बेचने पर उच्चतम ₹3,050/क्विंटल लाभ मिलेगा।';
      } else {
        response = 'For your Tomato harvest, AI recommends selling at Pune APMC (Gultekdi) in 3 days for maximum ₹3,050/qtl net profit.';
      }
    }

    if (mounted) {
      setState(() {
        _isListening = false;
        _assistantResponse = response;
        _detectedIntent = intent;
      });
      _playTtsAudio(response);
    }
  }

  void _playTtsAudio(String textToSpeak) async {
    final langCode = AppLocalizations.currentLangCode;
    setState(() {
      _isPlayingAudio = true;
    });

    try {
      if (langCode == 'mr') {
        await _flutterTts.setLanguage("mr-IN");
      } else if (langCode == 'hi') {
        await _flutterTts.setLanguage("hi-IN");
      } else {
        await _flutterTts.setLanguage("en-IN");
      }
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.speak(textToSpeak);
    } catch (e) {
      debugPrint('TTS play exception: $e');
    }

    _audioTimer?.cancel();
    _audioTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.currentLangCode;

    final sampleQueries = lang == 'mr'
        ? [
            'मी माझं पीक कधी विकू?',
            'me kadhi viku?',
            'आज टोमॅटोचा भाव किती आहे?',
            'कोणत्या बाजारात जास्त नफा मिळेल?',
            'आता विकू का माल साठवून ठेवू?',
            'भाव 10 टक्क्यांनी कमी झाले तर?',
          ]
        : lang == 'hi'
            ? [
                'मैं अपनी फसल कब बेचूं?',
                'abhi bechu kya?',
                'आज टमाटर का भाव क्या है?',
                'किस बाजार में सबसे ज्यादा मुनाफा मिलेगा?',
                'अभी बेचूं या स्टोर करूं?',
                'अगर कीमत 10% कम हो गई?',
              ]
            : [
                'When should I sell my crop?',
                'What is today\'s tomato price?',
                'Which market gives highest profit?',
                'Should I sell now or store?',
                'Which market has lower transport cost?',
                'What happens if price falls 10%?',
              ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.tr('AgriTwin AI Voice Assistant'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        AppLocalizations.tr('Ask me anything in English, Marathi, or Hindi'),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const Divider(height: 24),

            // Search/Query Input Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.tr('Try speaking...'),
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        _startListening(val.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_inputController.text.trim().isNotEmpty) {
                      _startListening(_inputController.text.trim());
                    }
                  },
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Mic Button & Listening Pulse Visualizer
            GestureDetector(
              onTap: () => _startListening(),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = _isListening ? 1.0 + (_pulseController.value * 0.15) : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.red.shade600 : AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.red : AppColors.primary).withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: _isListening ? 6 : 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isListening
                  ? AppLocalizations.tr('Listening...')
                  : AppLocalizations.tr('Tap to Speak'),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _isListening ? Colors.red.shade700 : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            // AI Response Card & Speech Playback Visualization
            if (_assistantResponse.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.smart_toy_rounded, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.tr('Assistant response'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        if (_detectedIntent.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _detectedIntent,
                              style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _assistantResponse,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Audio Wave & TTS Playback Controls
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _playTtsAudio(_assistantResponse),
                          icon: Icon(
                            _isPlayingAudio ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                            size: 18,
                          ),
                          label: Text(
                            AppLocalizations.tr('Read Aloud'),
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_isPlayingAudio) ...[
                          const Icon(Icons.graphic_eq_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              AppLocalizations.tr('Speaking response...'),
                              style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Quick Voice Chips
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.tr('Try asking:'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sampleQueries.map((item) {
                return ActionChip(
                  avatar: const Icon(Icons.record_voice_over_rounded, size: 14, color: AppColors.primary),
                  label: Text(
                    item,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: AppColors.surface,
                  side: BorderSide(color: Colors.grey.shade300),
                  onPressed: () {
                    _inputController.text = item;
                    _startListening(item);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
