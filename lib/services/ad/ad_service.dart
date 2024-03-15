import 'package:password_manager/services/ad/providers/ad_provider.dart';
import 'package:password_manager/services/ad/providers/admob_ad_provider.dart';

class AdService<T> {
  final AdProvider adProvider;

  const AdService(this.adProvider);

  factory AdService.fromAdMob() => AdService<T>(AdMobAdProvider());

  Future<void> initialize() async => adProvider.initialize();

  T? getBannerAd() => adProvider.getBannerAd();
}
