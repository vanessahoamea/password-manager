import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:password_manager/services/ad/ad_service.dart';

class AdCubit extends Cubit<Ad?> {
  final AdService<Ad> adService;
  BannerAd? bannerAd;

  AdCubit(this.adService) : super(null) {
    loadBannerAd();
  }

  void loadBannerAd() async {
    bannerAd = adService.getBannerAd() as BannerAd?;
    await bannerAd?.load();
  }

  void showBannerAd() {
    emit(bannerAd);
  }
}
