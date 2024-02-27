import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService localStorageService;

  ThemeCubit(this.localStorageService) : super(ThemeMode.system) {
    loadThemeFromLocalStorage();
  }

  Future<void> loadThemeFromLocalStorage() async {
    ThemeMode themeMode = await localStorageService.getThemeMode();
    emit(themeMode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await localStorageService.setThemeMode(themeMode);
    emit(themeMode);
  }
}
