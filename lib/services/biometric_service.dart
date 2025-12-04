import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  BiometricService._private();
  static final BiometricService instance = BiometricService._private();

  final LocalAuthentication _auth = LocalAuthentication();
  static const String _prefsKey = 'biometric_enabled';

  /// Returns true when device supports authentication APIs and at least one method is available.
  Future<bool> canCheckBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final available = await _auth.getAvailableBiometrics();
      debugPrint(
          '[BiometricService] isDeviceSupported=$supported canCheckBiometrics=$canCheck available=$available');
      return supported && (canCheck || available.isNotEmpty);
    } catch (e) {
      debugPrint('[BiometricService] canCheckBiometrics error: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getEnrolledBiometrics() async {
    try {
      final list = await _auth.getAvailableBiometrics();
      debugPrint('[BiometricService] enrolled biometrics: $list');
      return list;
    } catch (e) {
      debugPrint('[BiometricService] getEnrolledBiometrics error: $e');
      return <BiometricType>[];
    }
  }

  /// Authenticate. Use biometricOnly=false so PIN/pattern fallback is allowed on Android.
  Future<bool> authenticate(
      {String reason = 'Authenticate to continue'}) async {
    try {
      if (!await canCheckBiometrics()) {
        debugPrint(
            '[BiometricService] authenticate aborted: canCheckBiometrics==false');
        return false;
      }

      final options = AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
        useErrorDialogs: true,
      );

      debugPrint(
          '[BiometricService] starting authenticate (reason=$reason) platform=${Platform.operatingSystem}');
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: options,
      );
      debugPrint('[BiometricService] authenticate result: $didAuthenticate');
      return didAuthenticate;
    } on Exception catch (e, st) {
      debugPrint('[BiometricService] authenticate exception: $e\n$st');
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    debugPrint('[BiometricService] setEnabled=$enabled');
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool(_prefsKey) ?? false;
    debugPrint('[BiometricService] isEnabled=$v');
    return v;
  }

  Future<void> disable() async => setEnabled(false);
}
