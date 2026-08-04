/// AdMob IDs — Replace with real IDs from AdMob console
/// Test IDs are used by default for development
class AdConstants {
  // Test ad unit IDs (replace with production IDs before release)
  static const String testAppOpenId = 'ca-app-pub-3940256099942544/9257395921';
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String testPreRollId = 'ca-app-pub-3940256099942544/1033173712';

  // Production ad unit IDs (set these from your AdMob account)
  static const String prodBannerId = 'YOUR_BANNER_ID';
  static const String prodInterstitialId = 'YOUR_INTERSTITIAL_ID';
  static const String prodRewardedId = 'YOUR_REWARDED_ID';
  static const String prodPreRollId = 'YOUR_PREROLL_ID';

  // Use test IDs in debug mode
  static bool get useTestAds => true; // Set to false for production

  static String get bannerAdUnitId => useTestAds ? testBannerId : prodBannerId;
  static String get interstitialAdUnitId => useTestAds ? testInterstitialId : prodInterstitialId;
  static String get rewardedAdUnitId => useTestAds ? testRewardedId : prodRewardedId;
  static String get preRollAdUnitId => useTestAds ? testPreRollId : prodPreRollId;
}
