import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/local_storage_service.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  SettingsState({
    required this.themeMode,
    required this.locale,
  });
}

class SettingsCubit extends Cubit<SettingsState> {
  final LocalStorageService localStorageService;

  SettingsCubit({required this.localStorageService})
      : super(
          SettingsState(
            themeMode: ThemeMode.light,
            locale: const Locale('en'),
          ),
        );

  Future<void> loadSettings() async {
    final isDark = await localStorageService.getTheme();
    final languageCode = await localStorageService.getLanguage();

    emit(
      SettingsState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        locale: Locale(languageCode),
      ),
    );
  }

  Future<void> changeTheme(bool isDark) async {
    await localStorageService.saveTheme(isDark);

    emit(
      SettingsState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        locale: state.locale,
      ),
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    await localStorageService.saveLanguage(languageCode);

    emit(
      SettingsState(
        themeMode: state.themeMode,
        locale: Locale(languageCode),
      ),
    );
  }
}