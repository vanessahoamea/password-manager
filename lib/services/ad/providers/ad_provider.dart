abstract class AdProvider<T> {
  Future<void> initialize();
  T? getBannerAd();
}
