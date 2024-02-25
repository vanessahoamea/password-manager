import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_service.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  late AppUser user;
  late Stream<Iterable<Password>> passwords;
  Iterable<Password>? filteredPasswords;

  ManagerBloc(PasswordService passwordService)
      : super(const ManagerStateUninitialized()) {
    on<ManagerEventInitialize>((event, emit) async {
      user = event.user;

      try {
        passwords = passwordService.allPasswords(userId: user.id);

        emit(ManagerStatePasswordsPage(
          user: user,
          passwords: passwords,
          filteredPasswords: null,
          exception: null,
        ));
      } on Exception catch (e) {
        passwords = Stream.fromIterable([]);

        emit(ManagerStatePasswordsPage(
          user: user,
          passwords: passwords,
          filteredPasswords: null,
          exception: e,
        ));
      }
    });

    on<ManagerEventGoToPasswordsPage>((event, emit) {
      emit(ManagerStatePasswordsPage(
        user: user,
        passwords: passwords,
        filteredPasswords: filteredPasswords,
        exception: null,
      ));
    });

    on<ManagerEventGoToGeneratorPage>((event, emit) {
      emit(ManagerStateGeneratorPage(user: user));
    });

    on<ManagerEventGoToSettingsPage>((event, emit) {
      emit(ManagerStateSettingsPage(user: user));
    });

    on<ManagerEventFilterPasswords>((event, emit) {
      if (event.term.isEmpty) {
        filteredPasswords = null;
      } else {
        filteredPasswords = passwordService.filterPasswords(
          passwords: event.passwords,
          term: event.term,
        );
      }

      emit((state as ManagerStatePasswordsPage).copyWith(
        filteredPasswords: filteredPasswords,
      ));
    });
  }
}
