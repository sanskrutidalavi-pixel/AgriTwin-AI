import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agritwin_ai/main.dart';

void main() {
  testWidgets('AgriTwin AI complete Core Demo Flow test', (WidgetTester tester) async {
    // Set standard Android phone viewport (412 x 915 dp)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Launch App
    await tester.pumpWidget(const AgriTwinApp());
    await tester.pumpAndSettle();

    // 2. Verify Home Screen Dashboard Data
    expect(find.text('AgriTwin AI'), findsOneWidget);
    expect(find.textContaining('Rajesh Patil'), findsWidgets);
    expect(find.textContaining('Dharashiv'), findsWidgets);
    expect(find.text('1000 kg'), findsOneWidget);
    expect(find.text('₹28/kg'), findsOneWidget);
    expect(find.text('₹50,500'), findsWidgets);
    expect(find.text('87%'), findsWidgets);

    // Verify AI Recommendation Card
    expect(find.text('AI Recommendation'), findsOneWidget);
    expect(find.textContaining('Sell 60% now'), findsOneWidget);
    expect(find.textContaining('Store 40% for 30 days'), findsOneWidget);

    // 3. Test Flow Step: Scroll to reveal "View AI Decision" and tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    final viewDecisionBtn = find.text('View AI Decision');
    expect(viewDecisionBtn, findsOneWidget);
    await tester.tap(viewDecisionBtn);
    await tester.pumpAndSettle();

    // 4. Verify AI Decision Screen
    expect(find.text('AI Decision'), findsOneWidget);
    expect(find.text('Sell 60% Today • Store 40%'), findsOneWidget);
    expect(find.text('60% SELL'), findsOneWidget);
    expect(find.text('40% STORE'), findsOneWidget);
    expect(find.text('600 kg'), findsOneWidget);
    expect(find.text('400 kg'), findsOneWidget);
    expect(find.textContaining('Current demand is strong'), findsOneWidget);

    // 5. Test Flow Step: Scroll to reveal "Compare Markets" and tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();

    final compareMarketsBtn = find.text('Compare Markets');
    expect(compareMarketsBtn, findsOneWidget);
    await tester.tap(compareMarketsBtn);
    await tester.pumpAndSettle();

    // 6. Verify Market Analysis Screen
    expect(find.text('Market Analysis & Mandis'), findsOneWidget);
    expect(find.text('Predicted Price Trend'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('+18%'), findsOneWidget);
    expect(find.text('Market B (Solapur Hub)'), findsOneWidget);
    expect(find.text('AI Recommended'), findsOneWidget);

    // 7. Test Flow Step: Scroll to reveal "Run Scenario Simulation" and tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -450));
    await tester.pumpAndSettle();

    final runSimulationBtn = find.text('Run Scenario Simulation');
    expect(runSimulationBtn, findsOneWidget);
    await tester.tap(runSimulationBtn);
    await tester.pumpAndSettle();

    // 8. Verify Scenario Simulation Screen
    expect(find.text('Profit Scenario Simulation'), findsOneWidget);
    expect(find.text('SELL TODAY'), findsOneWidget);
    expect(find.text('WAIT 3 DAYS'), findsOneWidget);
    expect(find.text('WAIT 7 DAYS'), findsOneWidget);
    expect(find.text('AI Recommended: Wait 7 Days'), findsOneWidget);
    expect(find.text('₹42,000'), findsWidgets);
    expect(find.text('₹47,000'), findsWidgets);
    expect(find.text('₹52,000'), findsWidgets);

    // 9. Test Flow Step: Scroll to reveal "Apply Recommendation" and tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    final applyRecBtn = find.text('Apply Recommendation');
    expect(applyRecBtn, findsOneWidget);
    await tester.tap(applyRecBtn);
    await tester.pumpAndSettle();

    // Verify Confirmation Dialog
    expect(find.text('Recommendation Applied'), findsOneWidget);
    expect(find.text('AI recommendation applied successfully.'), findsOneWidget);

    // 10. Tap "Return to Dashboard"
    final returnBtn = find.text('Return to Dashboard');
    expect(returnBtn, findsOneWidget);
    await tester.tap(returnBtn);
    await tester.pumpAndSettle();

    // Verify back on Dashboard
    expect(find.text('AI Recommendation'), findsOneWidget);
  });

  testWidgets('AgriTwin AI Produce to AI Analysis Flow test', (WidgetTester tester) async {
    // Set standard Android phone viewport
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Launch App
    await tester.pumpWidget(const AgriTwinApp());
    await tester.pumpAndSettle();

    // 2. Switch to Produce Tab
    final produceTab = find.byIcon(Icons.inventory_2_outlined);
    expect(produceTab, findsOneWidget);
    await tester.tap(produceTab);
    await tester.pumpAndSettle();

    // 3. Verify My Produce Screen Details
    expect(find.text('My Produce'), findsOneWidget);
    expect(find.text('Tomato'), findsOneWidget);
    expect(find.text('1000 kg'), findsOneWidget);
    expect(find.text('Grade A'), findsOneWidget);
    expect(find.text('5 September'), findsOneWidget);
    expect(find.text('Fresh'), findsOneWidget);
    expect(find.text('400 kg'), findsOneWidget);
    expect(find.text('2 tonnes (2000 kg)'), findsOneWidget);

    // 4. Tap "Analyze with AI"
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    final analyzeBtn = find.text('Analyze with AI');
    expect(analyzeBtn, findsOneWidget);
    await tester.tap(analyzeBtn);

    // Advance frames to complete the route transition into AiAnalysisScreen
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // 5. Verify AI Analysis Screen
    expect(find.text('AI Analysis Engine'), findsOneWidget);
    expect(find.text('Market prices'), findsOneWidget);
    expect(find.text('Spoilage risk'), findsOneWidget);

    // Advance timer so all 8 analysis steps finish
    for (int i = 0; i < 9; i++) {
      await tester.pump(const Duration(milliseconds: 350));
    }
    await tester.pumpAndSettle();

    // Verify Analysis Complete
    expect(find.text('AI Analysis Complete'), findsOneWidget);
    expect(find.text('View AI Decision'), findsOneWidget);

    // 6. Tap "View AI Decision"
    final viewDecisionBtn = find.text('View AI Decision');
    await tester.tap(viewDecisionBtn);
    await tester.pumpAndSettle();

    // Verify AI Decision screen loaded
    expect(find.text('AI Decision'), findsOneWidget);
    expect(find.text('Sell 60% Today • Store 40%'), findsOneWidget);
  });

  testWidgets('AgriTwin AI complete Phase 3 Farmer Action to Profit & Feedback Flow test', (WidgetTester tester) async {
    // Set standard Android phone viewport (412 x 915 dp)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Launch App
    await tester.pumpWidget(const AgriTwinApp());
    await tester.pumpAndSettle();

    // 2. Switch to Buyers Tab
    final buyersTab = find.byIcon(Icons.storefront_outlined);
    expect(buyersTab, findsOneWidget);
    await tester.tap(buyersTab);
    await tester.pumpAndSettle();

    // 3. Verify Find Buyers Screen
    expect(find.text('Find Buyers'), findsOneWidget);
    expect(find.text('600 kg available for selling'), findsOneWidget);
    expect(find.text('ABC Hotel'), findsOneWidget);
    expect(find.text('XYZ Restaurant'), findsOneWidget);
    expect(find.text('FreshFood Processor'), findsOneWidget);
    expect(find.text('₹31/kg'), findsOneWidget);
    expect(find.text('300 kg'), findsOneWidget);

    // 4. Tap "View Details" on ABC Hotel (first card)
    final viewDetailsBtns = find.text('View Details');
    expect(viewDetailsBtns, findsWidgets);
    await tester.tap(viewDetailsBtns.first);
    await tester.pumpAndSettle();

    // 5. Verify Buyer Details Screen
    expect(find.text('Buyer Details'), findsOneWidget);
    expect(find.text('ABC Hotel'), findsOneWidget);
    expect(find.textContaining('8 km away'), findsOneWidget);
    expect(find.text('300 kg × ₹31/kg = ₹9,300'), findsOneWidget);

    // 6. Make Offer & Confirm Bottom Sheet
    final makeOfferBtn = find.text('Make Offer');
    expect(makeOfferBtn, findsOneWidget);
    await tester.tap(makeOfferBtn);
    await tester.pumpAndSettle();

    expect(find.text('Confirm Offer'), findsNWidgets(2));
    expect(find.textContaining('Sell 300 kg Tomato to ABC Hotel at ₹31/kg?'), findsOneWidget);

    final confirmOfferBtn = find.widgetWithText(ElevatedButton, 'Confirm Offer');
    expect(confirmOfferBtn, findsOneWidget);
    await tester.tap(confirmOfferBtn);
    await tester.pumpAndSettle();

    // 7. Verify Offer Sent state & Continue to FPO
    expect(find.text('Continue to FPO Aggregation'), findsOneWidget);
    await tester.tap(find.text('Continue to FPO Aggregation'));
    await tester.pumpAndSettle();

    // 8. Verify FPO Aggregation Screen
    expect(find.text('FPO Aggregation'), findsOneWidget);
    expect(find.text('Collective Selling Opportunity'), findsOneWidget);
    expect(find.text('1200 kg'), findsWidgets);
    expect(find.textContaining('Rajesh Patil'), findsOneWidget);
    expect(find.text('Farmer A'), findsNWidgets(2));
    expect(find.text('Farmer B'), findsNWidgets(2));
    expect(find.text('Buyer requirement fulfilled'), findsOneWidget);
    expect(find.text('AI Benefit'), findsOneWidget);

    // 9. Optimize Logistics
    await tester.drag(find.byType(ListView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    final optimizeLogisticsBtn = find.text('Optimize Logistics');
    expect(optimizeLogisticsBtn, findsOneWidget);
    await tester.tap(optimizeLogisticsBtn);
    await tester.pumpAndSettle();

    // 10. Verify Logistics Screen
    expect(find.text('Logistics Optimization'), findsOneWidget);
    expect(find.text('1200 kg collective shipment'), findsOneWidget);
    expect(find.text('Transport A'), findsOneWidget);
    expect(find.text('Transport B'), findsOneWidget);
    expect(find.text('FPO Collective Transport'), findsOneWidget);
    expect(find.text('₹1,500'), findsOneWidget);

    final selectTransportBtn = find.text('Select Recommended Transport');
    expect(selectTransportBtn, findsOneWidget);
    await tester.tap(selectTransportBtn);
    await tester.pumpAndSettle();

    expect(find.text('Check Storage'), findsOneWidget);
    await tester.tap(find.text('Check Storage'));
    await tester.pumpAndSettle();

    // 11. Verify Storage Screen
    expect(find.text('Storage Recommendation'), findsOneWidget);
    expect(find.text('400 kg Tomato requires storage.'), findsOneWidget);
    expect(find.text('Cold Storage A'), findsOneWidget);
    expect(find.text('FPO Storage'), findsOneWidget);
    expect(find.text('₹400/day'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    final useStorageBtn = find.text('Use Recommended Storage');
    expect(useStorageBtn, findsOneWidget);
    await tester.tap(useStorageBtn);
    await tester.pumpAndSettle();

    // Scroll up so button is completely above the floating SnackBar
    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();

    final viewAlertBtn = find.text('View Smart Alert');
    expect(viewAlertBtn, findsOneWidget);
    await tester.tap(viewAlertBtn);
    await tester.pumpAndSettle();

    // 12. Verify Smart Alert Screen
    expect(find.text('Smart Alert'), findsOneWidget);
    expect(find.text('Spoilage Risk Increasing'), findsOneWidget);
    expect(find.text('Safe storage remaining'), findsOneWidget);
    expect(find.text('24 hours'), findsOneWidget);
    expect(find.text('Sell Now'), findsNWidgets(2));

    await tester.drag(find.byType(ListView).first, const Offset(0, -250));
    await tester.pumpAndSettle();

    final sellNowBtn = find.widgetWithText(ElevatedButton, 'Sell Now');
    expect(sellNowBtn, findsOneWidget);
    await tester.tap(sellNowBtn);
    await tester.pumpAndSettle();

    // 13. Verify Transaction Screen
    expect(find.text('Confirm Transaction'), findsOneWidget);
    expect(find.text('Trade Invoice Summary'), findsOneWidget);
    expect(find.text('300 kg × ₹31/kg = ₹9,300'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -250));
    await tester.pumpAndSettle();

    final confirmPaymentBtn = find.text('Confirm Delivery & Payment');
    expect(confirmPaymentBtn, findsOneWidget);
    await tester.tap(confirmPaymentBtn);

    // Pump timer frames for simulated processing (~1600ms)
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 350));
    }
    await tester.pumpAndSettle();

    // 14. Verify Payment Success Screen
    expect(find.text('Payment Received'), findsWidgets);
    expect(find.text('₹9,300'), findsOneWidget);
    expect(find.text('Successful'), findsOneWidget);
    expect(find.text('TRX-7025'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -250));
    await tester.pumpAndSettle();

    final viewProfitBtn = find.text('View Profit Result');
    expect(viewProfitBtn, findsOneWidget);
    await tester.tap(viewProfitBtn);
    await tester.pumpAndSettle();

    // 15. Verify Profit Result Screen
    expect(find.text('Profit Result'), findsOneWidget);
    expect(find.text('EXPECTED PROFIT'), findsOneWidget);
    expect(find.text('₹50,500'), findsOneWidget);
    expect(find.text('ACTUAL PROFIT'), findsOneWidget);
    expect(find.text('₹49,800'), findsOneWidget);
    expect(find.text('Difference: ₹700'), findsOneWidget);
    expect(find.text('98.6%'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    final giveFeedbackBtn = find.text('Give Feedback');
    expect(giveFeedbackBtn, findsOneWidget);
    await tester.tap(giveFeedbackBtn);
    await tester.pumpAndSettle();

    // 16. Verify Feedback Screen
    expect(find.text('Farmer Feedback'), findsOneWidget);
    expect(find.text('How useful was the AI recommendation?'), findsOneWidget);
    expect(find.text('What did you like?'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    final submitFeedbackBtn = find.text('Submit Feedback');
    expect(submitFeedbackBtn, findsOneWidget);
    await tester.tap(submitFeedbackBtn);
    await tester.pumpAndSettle();

    // Verify Thank You & Return to Dashboard
    expect(find.text('Thank You!'), findsOneWidget);
    final backToDashboardBtn = find.text('Back to Dashboard');
    expect(backToDashboardBtn, findsOneWidget);
    await tester.tap(backToDashboardBtn);
    await tester.pumpAndSettle();

    // Verify successfully returned to root dashboard
    expect(find.text('AgriTwin AI'), findsOneWidget);
    expect(find.text('AI Recommendation'), findsOneWidget);
  });
}
