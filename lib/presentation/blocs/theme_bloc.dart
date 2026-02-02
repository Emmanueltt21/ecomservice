import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomservics/core/constants/app_constants.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;
  const ChangeTheme(this.themeMode);
  @override
  List<Object> get props => [themeMode];
}

class GetTheme extends ThemeEvent {}

// State
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
  @override
  List<Object> get props => [themeMode];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences}) : super(const ThemeState(ThemeMode.system)) {
    on<ChangeTheme>(_onChangeTheme);
    on<GetTheme>(_onGetTheme);
    add(GetTheme());
  }

  void _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    await sharedPreferences.setString(AppConstants.themeKey, event.themeMode.toString());
    emit(ThemeState(event.themeMode));
  }

  void _onGetTheme(GetTheme event, Emitter<ThemeState> emit) {
    final themeString = sharedPreferences.getString(AppConstants.themeKey);
    if (themeString != null) {
      if (themeString == ThemeMode.light.toString()) {
        emit(const ThemeState(ThemeMode.light));
      } else if (themeString == ThemeMode.dark.toString()) {
        emit(const ThemeState(ThemeMode.dark));
      } else {
        emit(const ThemeState(ThemeMode.system)); // Default
      }
    }
  }
}
