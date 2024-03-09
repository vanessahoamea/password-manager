import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/biometrics/biometrics_service.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_service.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  late AppUser user;
  late Stream<Iterable<Password>> passwords;
  late bool supportsBiometrics;
  late bool hasBiometricsEnabled;
  String? searchTerm;
  Iterable<Password>? filteredPasswords;

  ManagerBloc(
    PasswordService passwordService,
    LocalStorageService localStorageService,
    BiometricsService biometricsService,
  ) : super(const ManagerStateUninitialized()) {
    on<ManagerEventInitialize>((event, emit) async {
      user = event.user;

      try {
        passwords = passwordService.allPasswords(userId: user.id);
        supportsBiometrics = await biometricsService.supportsBiometrics();

        if (supportsBiometrics) {
          hasBiometricsEnabled =
              await localStorageService.getHasBiometricsEnabled();
        } else {
          hasBiometricsEnabled = false;
        }

        emit(ManagerStatePasswordsPage(
          user: user,
          showToast: false,
          passwords: passwords,
          searchTerm: null,
          filteredPasswords: null,
          exception: null,
        ));
      } on Exception catch (e) {
        passwords = Stream.fromIterable([]);
        supportsBiometrics = false;
        hasBiometricsEnabled = false;

        emit(ManagerStatePasswordsPage(
          user: user,
          showToast: false,
          passwords: passwords,
          searchTerm: null,
          filteredPasswords: null,
          exception: e,
        ));
      }
    });

    on<ManagerEventGoToPasswordsPage>((event, emit) {
      emit(ManagerStatePasswordsPage(
        user: user,
        showToast: false,
        passwords: passwords,
        searchTerm: searchTerm,
        filteredPasswords: filteredPasswords,
        exception: null,
      ));
    });

    on<ManagerEventGoToGeneratorPage>((event, emit) {
      emit(ManagerStateGeneratorPage(user: user));
    });

    on<ManagerEventGoToSettingsPage>((event, emit) {
      emit(ManagerStateSettingsPage(
        user: user,
        supportsBiometrics: supportsBiometrics,
        hasBiometricsEnabled: hasBiometricsEnabled,
      ));
    });

    on<ManagerEventGoToSinglePassword>((event, emit) async {
      try {
        final [encryptionKey, iv] =
            await localStorageService.getEncryptionKey();
        String decryptedPassword = '';

        if (event.password != null) {
          decryptedPassword = await PasswordService.decrypt(
            encryptedPassword: event.password!.encryptedPassword,
            encryptionKey: encryptionKey,
            iv: iv,
          );
        }

        emit(ManagerStateSinglePasswordPage(
          user: user,
          showToast: false,
          password: event.password,
          decryptedPassword: decryptedPassword,
          showPassword: false,
          isLoading: false,
          exception: null,
        ));
      } on Exception catch (e) {
        emit((state as ManagerStatePasswordsPage).copyWith(exception: e));
      }
    });

    on<ManagerEventFilterPasswords>((event, emit) {
      if (event.term.isEmpty) {
        searchTerm = null;
        filteredPasswords = null;
      } else {
        searchTerm = event.term;
        filteredPasswords = passwordService.filterPasswords(
          passwords: event.passwords,
          term: event.term,
        );
      }

      emit((state as ManagerStatePasswordsPage).copyWith(
        searchTerm: searchTerm,
        filteredPasswords: filteredPasswords,
      ));
    });

    on<ManagerEventToggleBiometrics>((event, emit) async {
      hasBiometricsEnabled = !hasBiometricsEnabled;
      await localStorageService.toggleBiometrics(hasBiometricsEnabled);

      emit((state as ManagerStateSettingsPage).copyWith(
        hasBiometricsEnabled: hasBiometricsEnabled,
      ));
    });

    on<ManagerEventUpdateSinglePasswordState>((event, emit) {
      emit((state as ManagerStateSinglePasswordPage).copyWith(
        showPassword: event.showPassword,
      ));
    });

    on<ManagerEventSavePassword>((event, emit) async {
      emit((state as ManagerStateSinglePasswordPage).copyWith(
        isLoading: true,
        loadingMessage:
            '${event.id == null ? "Adding" : "Updating"} password...',
      ));

      try {
        final [encryptionKey, iv] =
            await localStorageService.getEncryptionKey();
        final encryptedPassword = event.password.isNotEmpty
            ? await PasswordService.encrypt(
                plaintextPassword: event.password,
                encryptionKey: encryptionKey,
                iv: iv,
              )
            : event.password;

        // create new password
        if (event.id == null) {
          Password password = Password(
            userId: user.id,
            website: event.website,
            username: event.username,
            encryptedPassword: encryptedPassword,
          );
          await passwordService.createPassword(password: password);
        }
        // update existing password
        else {
          Password password = Password(
            id: event.id!,
            userId: user.id,
            website: event.website,
            username: event.username,
            encryptedPassword: encryptedPassword,
          );
          await passwordService.updatePassword(password: password);
        }

        emit(ManagerStatePasswordsPage(
          user: null,
          showToast: true,
          toastMessage:
              'Password ${event.id == null ? "created" : "updated"} successfully.',
          passwords: passwords,
          searchTerm: searchTerm,
          filteredPasswords: filteredPasswords,
          exception: null,
        ));
      } on Exception catch (e) {
        emit((state as ManagerStateSinglePasswordPage).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<ManagerEventDeletePassword>((event, emit) async {
      emit((state as ManagerStateSinglePasswordPage).copyWith(
        isLoading: true,
        loadingMessage: 'Deleting password...',
      ));

      try {
        await passwordService.deletePassword(passwordId: event.passwordId);
        emit(ManagerStatePasswordsPage(
          user: null,
          showToast: true,
          toastMessage: 'Password deleted successfully.',
          passwords: passwords,
          searchTerm: searchTerm,
          filteredPasswords: filteredPasswords,
          exception: null,
        ));
      } on Exception catch (e) {
        emit((state as ManagerStateSinglePasswordPage).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });
  }
}
