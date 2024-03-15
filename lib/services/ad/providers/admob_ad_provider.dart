import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:password_manager/services/ad/providers/ad_provider.dart';

class AdMobAdProvider extends AdProvider<BannerAd> {
  static final AdMobAdProvider _instance = AdMobAdProvider._internal();

  factory AdMobAdProvider() {
    return _instance;
  }

  AdMobAdProvider._internal();

  String get _bannerAdUnitId {
    if (kReleaseMode) {
      // production values
      return Platform.isAndroid
          ? const String.fromEnvironment('ADMOB_BANNER_AD_UNIT_ID_ANDROID')
          : const String.fromEnvironment('ADMOB_BANNER_AD_UNIT_ID_IOS');
    } else {
      // development values
      return Platform.isAndroid
          ? const String.fromEnvironment('ADMOB_BANNER_AD_UNIT_ID_ANDROID_TEST')
          : const String.fromEnvironment('ADMOB_BANNER_AD_UNIT_ID_IOS_TEST');
    }
  }

  @override
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  @override
  BannerAd? getBannerAd() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return null;
    }

    return BannerAd(
      size: AdSize.fullBanner,
      adUnitId: _bannerAdUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
  }
}
