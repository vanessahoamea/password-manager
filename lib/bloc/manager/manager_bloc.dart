import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/services/auth/app_user.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  late AppUser user;

  ManagerBloc() : super(const ManagerStateUninitialized()) {
    on<ManagerEventInitialize>((event, emit) {
      user = event.user;
      emit(ManagerStatePasswordsPage(user: user));
    });

    on<ManagerEventGoToPasswordsPage>((event, emit) {
      emit(ManagerStatePasswordsPage(user: user));
    });

    on<ManagerEventGoToGeneratorPage>((event, emit) {
      emit(ManagerStateGeneratorPage(user: user));
    });

    on<ManagerEventGoToSettingsPage>((event, emit) {
      emit(ManagerStateSettingsPage(user: user));
    });
  }
}
