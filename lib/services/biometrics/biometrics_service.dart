import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/services/biometrics/biometrics_exceptions.dart';

class BiometricsService {
  static final BiometricsService _instance = BiometricsService._internal();
  final LocalAuthentication auth = LocalAuthentication();

  factory BiometricsService() => _instance;

  BiometricsService._internal();

  Future<bool> supportsBiometrics() async {
    try {
      final [canCheckBiometrics, isDeviceSupported] = await Future.wait([
        auth.canCheckBiometrics,
        auth.isDeviceSupported(),
      ]);
      return canCheckBiometrics || isDeviceSupported;
    } on MissingPluginException catch (_) {
      return false;
    }
  }

  Future<bool> hasBiometricsEnabled() async {
    final biometrics = await auth.getAvailableBiometrics();
    return biometrics
        .where((biometric) => biometric != BiometricType.weak)
        .toList()
        .isNotEmpty;
  }

  void authenticate() async {
    try {
      await auth.authenticate(
        localizedReason: 'Authenticate to access your passwords.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (_) {
      throw BiometricsException();
    }
  }
}
