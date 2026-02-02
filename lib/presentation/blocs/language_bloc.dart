import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomservics/core/constants/app_constants.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;
  const ChangeLanguage(this.locale);
  @override
  List<Object> get props => [locale];
}

class GetLanguage extends LanguageEvent {}

// State
class LanguageState extends Equatable {
  final Locale locale;
  const LanguageState(this.locale);
  @override
  List<Object> get props => [locale];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageBloc({required this.sharedPreferences}) : super(const LanguageState(Locale('en'))) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<GetLanguage>(_onGetLanguage);
    add(GetLanguage());
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    await sharedPreferences.setString(AppConstants.languageKey, event.locale.languageCode);
    emit(LanguageState(event.locale));
  }

  void _onGetLanguage(GetLanguage event, Emitter<LanguageState> emit) {
    final languageCode = sharedPreferences.getString(AppConstants.languageKey);
    if (languageCode != null) {
      emit(LanguageState(Locale(languageCode)));
    }
  }
}
