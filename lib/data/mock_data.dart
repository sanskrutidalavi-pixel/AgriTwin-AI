import '../models/risk_level.dart';
import '../models/farmer.dart';
import '../models/produce.dart';
import '../models/market.dart';
import '../models/buyer.dart';
import '../models/logistics.dart';
import '../models/storage.dart';
import '../models/transaction.dart';
import '../models/ai_recommendation.dart';
import '../models/market_comparison.dart';
import '../models/profit_scenario.dart';
import '../models/fpo_contribution.dart';
import '../models/transport_option.dart';
import '../models/storage_option.dart';

/// Central repository of Pune-specific mock data for AgriTwin AI Prototype
class MockData {
  MockData._();

  // Active User Role state for interactive switching
  static String activeUserRole = 'Farmer'; // 'Farmer', 'Buyer', 'Transport Agency', 'Admin'
  static String activeLanguage = 'English'; // 'English', 'Marathi', 'Hindi'

  // Payment status state across Buyer & Farmer
  static String buyerPaymentStatus = 'Pending Buyer Acceptance';
  static bool isPaymentCompleted = false;

  // Registered Harvest Batches list
  static List<Map<String, String>> registeredHarvestBatches = [
    {
      'cropName': 'Tomato (Abhinav Hybrid)',
      'quantity': '1000 kg',
      'grade': 'Grade A',
      'harvestDate': '01-Sep-2026',
      'location': 'Haveli, Pune',
      'storageStatus': 'Sahyadri Cold Storage Hadapsar',
      'status': 'Active Monitored Lot #AT-TOM-1000',
    },
  ];

  // 1. Farmer Profile - Ramesh Patil (Haveli, Pune, Maharashtra)
  static final Farmer sampleFarmer = Farmer(
    id: 'FARM-PUNE-2026-01',
    name: 'Ramesh Patil',
    district: 'Pune (Haveli)',
    state: 'Maharashtra',
    landSizeAcres: 6.5,
    primaryCrops: const ['Tomato (Abhinav)', 'Onion', 'Capsicum'],
    creditScore: 780,
    kycVerified: true,
    phoneNumber: '+91 98220 12345',
    digitalTwinId: 'DT-PUNE-411001',
    totalYieldEstimatedQuintals: 10.0, // 1000 kg
  );

  // 2. Active Produce - Tomato (Harvest Lot 1000 kg)
  static Produce sampleProduce = Produce(
    id: 'PROD-TOM-PUNE-01',
    cropName: 'Tomato',
    variety: 'Abhinav Hybrid F1',
    quantityQuintals: 10.0, // 1000 kg
    harvestDate: DateTime(2026, 9, 1),
    storageLifeDaysRemaining: 3,
    expectedPricePerQuintal: 3200.0,
    currentMarketPricePerQuintal: 2900.0,
    qualityGrade: 'Grade A',
    spoilageRisk: RiskLevel.medium,
  );

  // 3. Predicted Prices & Market Demand (Pune Region)
  static const Map<String, double> predictedPrices = {
    'Today': 2900.0,
    '3 Days': 3200.0,
    '7 Days': 3450.0,
    '15 Days': 3600.0,
  };

  static const String marketDemandStatus = 'High Demand (Pune Urban Cluster)';
  static const String expectedDemandIncrease = '+22%';

  // 4. Pune Market Net Profit Comparisons
  static const List<MarketComparison> marketComparisons = [
    MarketComparison(
      name: 'Pune Market Yard (Gultekdi APMC)',
      grossPricePerQuintal: 3300.0,
      transportCostPerQuintal: 150.0,
      spoilageCostPerQuintal: 100.0,
      netProfitPerQuintal: 3050.0,
      isAiRecommended: true,
      distanceInfo: '12 km away • Direct Mandi Access',
    ),
    MarketComparison(
      name: 'Pimpri APMC Mandi (Pimpri-Chinchwad)',
      grossPricePerQuintal: 3150.0,
      transportCostPerQuintal: 250.0,
      spoilageCostPerQuintal: 150.0,
      netProfitPerQuintal: 2750.0,
      isAiRecommended: false,
      distanceInfo: '22 km away',
    ),
    MarketComparison(
      name: 'Hadapsar APMC Market (Hadapsar Pune)',
      grossPricePerQuintal: 3100.0,
      transportCostPerQuintal: 120.0,
      spoilageCostPerQuintal: 120.0,
      netProfitPerQuintal: 2860.0,
      isAiRecommended: false,
      distanceInfo: '8 km away',
    ),
  ];

  // 5. Profit Scenarios for Simulation
  static const List<ProfitScenario> profitScenarios = [
    ProfitScenario(
      title: 'SELL TODAY',
      timeFrame: 'Immediate Dispatch',
      expectedProfit: 43500.0,
      risk: RiskLevel.low,
      isAiRecommended: false,
      description: 'Guaranteed immediate sale at ₹29/kg. Zero spoilage risk, but misses upcoming Pune market price surge.',
    ),
    ProfitScenario(
      title: 'WAIT 3 DAYS',
      timeFrame: 'Short Holding (Cold Storage)',
      expectedProfit: 48000.0,
      risk: RiskLevel.medium,
      isAiRecommended: false,
      description: 'Capitalizes on hotel demand peak over weekend. Requires Sahyadri Cold Storage.',
    ),
    ProfitScenario(
      title: 'WAIT 7 DAYS',
      timeFrame: 'Optimal Peak Price',
      expectedProfit: 53500.0,
      risk: RiskLevel.high,
      isAiRecommended: true,
      description: 'Highest projected returns at ₹34.5/kg. AI recommends holding 40% stock while selling 60% today.',
    ),
  ];

  // 6. Real Verified Buyers in Pune
  static final List<Buyer> buyerList = [
    const Buyer(
      id: 'BUY-SHREE-GURUKRUPA',
      companyName: 'Shree Gurukrupa Restaurant',
      buyerType: BuyerType.restaurant,
      location: 'Deccan Gymkhana, Pune',
      trustScore: 4.9,
      paymentTerms: 'Instant UPI / Escrow Payment',
      activeDemandCrop: 'Tomato (Grade A)',
      demandQuantityQuintals: 2.0,
      offeredPricePerQuintal: 3000.0,
      pricePerKg: 30.0,
      requiredKg: 200.0,
      distanceKm: 14.0,
      estimatedRevenue: 6000.0,
      escrowProtected: true,
      completedDeals: 124,
      isAiRecommended: true,
    ),
    const Buyer(
      id: 'BUY-DURVANKUR',
      companyName: 'Durvankur Dining Hall',
      buyerType: BuyerType.restaurant,
      location: 'Tilak Road, Pune',
      trustScore: 4.8,
      paymentTerms: 'Direct Bank Settlement (T+0)',
      activeDemandCrop: 'Tomato',
      demandQuantityQuintals: 3.0,
      offeredPricePerQuintal: 3100.0,
      pricePerKg: 31.0,
      requiredKg: 300.0,
      distanceKm: 11.0,
      estimatedRevenue: 9300.0,
      escrowProtected: true,
      completedDeals: 198,
      isAiRecommended: false,
    ),
    const Buyer(
      id: 'BUY-CHITALE-FOODS',
      companyName: 'Chitale Foods & Processors',
      buyerType: BuyerType.foodProcessor,
      location: 'Kothrud, Pune',
      trustScore: 4.95,
      paymentTerms: 'Institutional Bulk Escrow',
      activeDemandCrop: 'Tomato (Ketchup Grade)',
      demandQuantityQuintals: 5.0,
      offeredPricePerQuintal: 3200.0,
      pricePerKg: 32.0,
      requiredKg: 500.0,
      distanceKm: 16.0,
      estimatedRevenue: 16000.0,
      escrowProtected: true,
      completedDeals: 412,
      isAiRecommended: false,
    ),
    const Buyer(
      id: 'BUY-HOTEL-VAISHALI',
      companyName: 'Hotel Vaishali',
      buyerType: BuyerType.hotel,
      location: 'FC Road, Pune',
      trustScore: 4.85,
      paymentTerms: 'Daily Direct Transfer',
      activeDemandCrop: 'Tomato (Salad Grade)',
      demandQuantityQuintals: 2.5,
      offeredPricePerQuintal: 3150.0,
      pricePerKg: 31.5,
      requiredKg: 250.0,
      distanceKm: 15.0,
      estimatedRevenue: 7875.0,
      escrowProtected: true,
      completedDeals: 160,
      isAiRecommended: false,
    ),
    const Buyer(
      id: 'BUY-SUJATA-CATERERS',
      companyName: 'Sujata Caterers',
      buyerType: BuyerType.caterer,
      location: 'Shivajinagar, Pune',
      trustScore: 4.7,
      paymentTerms: 'Spot Payment upon delivery',
      activeDemandCrop: 'Tomato',
      demandQuantityQuintals: 1.5,
      offeredPricePerQuintal: 2950.0,
      pricePerKg: 29.5,
      requiredKg: 150.0,
      distanceKm: 13.0,
      estimatedRevenue: 4425.0,
      escrowProtected: true,
      completedDeals: 85,
      isAiRecommended: false,
    ),
  ];

  // 7. FPO Aggregation Contributions (Pune Farmers Pooling 1,000 kg Tomatoes)
  static const double fpoBuyerRequirementKg = 1000.0;
  static const String fpoTargetBuyerName = 'Chitale Foods & Processors (Kothrud, Pune)';
  static const List<FpoFarmerContribution> fpoFarmerContributions = [
    FpoFarmerContribution(
      farmerName: 'Ramesh Patil',
      crop: 'Tomato (Grade A)',
      quantityKg: 400.0,
      location: 'Haveli, Pune',
      isCurrentFarmer: true,
    ),
    FpoFarmerContribution(
      farmerName: 'Suresh Pawar',
      crop: 'Tomato (Grade A)',
      quantityKg: 500.0,
      location: 'Shirur, Pune',
    ),
    FpoFarmerContribution(
      farmerName: 'Anita Deshmukh',
      crop: 'Tomato (Grade A)',
      quantityKg: 100.0,
      location: 'Khed, Pune',
    ),
  ];

  // 8. Logistics Optimization Options (Pune Transport Agencies)
  static const List<TransportOption> transportOptions = [
    TransportOption(
      id: 'TRANS-PUNE-EXPRESS',
      title: 'Pune Express Agri-Transporters',
      cost: 2200.0,
      durationText: '1.5 hours',
      statusText: 'Dedicated Pickup Vehicle',
      isAiRecommended: false,
      description: 'Direct door-to-door transport from farm in Haveli to Kothrud Pune.',
    ),
    TransportOption(
      id: 'TRANS-MAHA-FREIGHT',
      title: 'Maharashtra Kisan Freight (Bhosari)',
      cost: 1800.0,
      durationText: '2.0 hours',
      statusText: 'Shared Route Mini-Truck',
      isAiRecommended: false,
      description: 'Shared route transport covering Haveli & Hadapsar routes.',
    ),
    TransportOption(
      id: 'TRANS-PUNE-FPO-LOGISTICS',
      title: 'FPO Collective Transport Pune',
      cost: 1200.0,
      durationText: '1.5 hours',
      statusText: 'Grouped Farm Route (Available)',
      isAiRecommended: true,
      comparisonNote: '₹1,000 cheaper than single transport',
      description: 'Pooled transport with Suresh Pawar & Anita Deshmukh. Lowest cost per kg.',
    ),
  ];

  // 9. Storage Options in Pune
  static const List<StorageOption> storageOptions = [
    StorageOption(
      id: 'STR-SAHYADRI-PUNE',
      name: 'Sahyadri Cold Storage (Hadapsar Pune)',
      ratePerKgPerDay: 2.5,
      distanceKm: 5.0,
      capacityText: '15 Tonnes Available',
      isAiRecommended: true,
      dailyCostFor400Kg: 1000.0,
      potentialSavingPerDay: 400.0,
    ),
    StorageOption(
      id: 'STR-NATIONAL-BHOSARI',
      name: 'National Cold Storage (Bhosari Pune)',
      ratePerKgPerDay: 3.5,
      distanceKm: 18.0,
      capacityText: '30 Tonnes Available',
      isAiRecommended: false,
      dailyCostFor400Kg: 1400.0,
      potentialSavingPerDay: 0.0,
    ),
    StorageOption(
      id: 'STR-KRISHI-GULTEKDI',
      name: 'Pune Krishi Sheetagrah (Gultekdi Pune)',
      ratePerKgPerDay: 3.0,
      distanceKm: 12.0,
      capacityText: '10 Tonnes Available',
      isAiRecommended: false,
      dailyCostFor400Kg: 1200.0,
      potentialSavingPerDay: 200.0,
    ),
  ];

  // 10. Smart Alert Telemetry (24-Hour Spoilage Warning)
  static const String smartAlertTitle = '⚠️ 24-HOUR SPOILAGE RISK ALERT!';
  static const String smartAlertSafeStorageRemaining = '24 hours';
  static const double smartAlertDemandKg = 200.0;
  static const double smartAlertOfferPricePerKg = 30.0;
  static const double smartAlertPotentialRevenue = 6000.0;
  static const String smartAlertRecommendation = 'Sell 60% to Shree Gurukrupa Restaurant Deccan Pune & Store 40% at Sahyadri Cold Storage Hadapsar!';
  static const String smartAlertExplanation =
      'Tomato shelf life expires in 24 hours. Selling 600 kg today avoids ₹12,000 potential spoilage loss while capturing high restaurant prices in Pune.';

  // 11. Quality Verification Photo Metadata
  static const String photoTimestamp = '06-Sep-2026 at 03:30 PM';
  static const String photoLocation = 'Haveli Farm Lot #4, Pune';
  static const String photoCropCondition = 'Grade A Firm Organic Red Tomatoes';
  static const String photoShelfLife = 'Fresh for 4 Days under ambient temperature (12 days in cold storage)';

  // 12. Transaction Confirmation Data
  static const String activeTransactionId = 'TRX-PUNE-8812';
  static const String activeBuyerName = 'Shree Gurukrupa Restaurant (Deccan, Pune)';
  static const String activeProduceCrop = 'Tomato (Grade A)';
  static const double activeQuantityKg = 200.0;
  static const double activePricePerKg = 30.0;
  static const double activeTotalAmount = 6000.0;

  // 13. AI Profit Accuracy Comparison
  static const double expectedProfitAmount = 50500.0;
  static const double actualProfitAmount = 49800.0;
  static const double profitDifference = 700.0;
  static const double predictionAccuracyPercent = 98.6;

  // 14. Mandi List for General Views
  static final List<MarketMandi> marketList = [
    MarketMandi(
      id: 'MND-GULTEKDI',
      mandiName: 'Pune Market Yard (Gultekdi APMC)',
      district: 'Pune',
      state: 'Maharashtra',
      distanceKm: 12.0,
      cropName: 'Tomato',
      modalPricePerQuintal: 3300.0,
      minPricePerQuintal: 2900.0,
      maxPricePerQuintal: 3600.0,
      trend: PriceTrend.up,
      dailyArrivalsQuintals: 4500.0,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MarketMandi(
      id: 'MND-PIMPRI',
      mandiName: 'Pimpri APMC Mandi',
      district: 'Pune',
      state: 'Maharashtra',
      distanceKm: 22.0,
      cropName: 'Tomato',
      modalPricePerQuintal: 3150.0,
      minPricePerQuintal: 2800.0,
      maxPricePerQuintal: 3400.0,
      trend: PriceTrend.up,
      dailyArrivalsQuintals: 2800.0,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  static final List<LogisticsProvider> logisticsList = [
    const LogisticsProvider(
      id: 'LOG-PUNE-EXPRESS',
      providerName: 'Pune Express Agri-Transporters',
      vehicleType: VehicleType.miniTruck,
      capacityQuintals: 20.0,
      baseRatePerKm: 22.0,
      estimatedPickupHours: 1,
      rating: 4.9,
      coldChainCapable: true,
      gpsLiveTracking: true,
      contactNumber: '+91 98220 99887',
    ),
  ];

  static final List<StorageFacility> storageList = [
    const StorageFacility(
      id: 'STR-SAHYADRI',
      facilityName: 'Sahyadri Cold Storage (Hadapsar Pune)',
      storageType: StorageType.coldStorage,
      location: 'Hadapsar Industrial Zone, Pune',
      distanceKm: 5.0,
      capacityQuintals: 150.0,
      availableCapacityQuintals: 40.0,
      monthlyRentPerQuintal: 50.0,
      currentTempCelsius: 11.0,
      humidityPercentage: 88.0,
      governmentSubsidized: true,
      wdraRegistered: true,
    ),
  ];

  static final List<TransactionRecord> transactionList = [
    TransactionRecord(
      id: 'TXN-PUNE-01',
      transactionId: 'TRX-PUNE-8812',
      date: DateTime.now(),
      produceCrop: 'Tomato (Grade A)',
      buyerName: 'Shree Gurukrupa Restaurant (Deccan Pune)',
      quantityQuintals: 2.0,
      ratePerQuintal: 3000.0,
      totalAmount: 6000.0,
      status: TransactionStatus.completed,
      escrowReferenceId: 'ESC-PUNE-998821',
    ),
  ];

  static final List<AiRecommendation> recommendations = [
    AiRecommendation(
      id: 'AI-PUNE-REC-01',
      title: 'Optimal Pune Profit Strategy: Sell 60% Today to Shree Gurukrupa, Store 40% at Sahyadri Cold Storage',
      description:
          'High demand in Deccan & FC Road restaurants coupled with expected 15% price rise at Gultekdi APMC in 3 days. Selling 600 kg immediately locks ₹18,000 cash flow while 400 kg in cold storage maximizes profit.',
      category: RecommendationCategory.marketArbitrage,
      recommendedAction: 'Sell 600 kg to Shree Gurukrupa Restaurant Deccan Pune at ₹30/kg. Store 400 kg at Sahyadri Cold Storage Hadapsar.',
      projectedOutcome: '₹53,500 expected total net profit',
      confidenceScore: 0.92,
      riskLevel: RiskLevel.low,
      generatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];
}
