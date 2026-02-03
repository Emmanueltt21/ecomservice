import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  const SignupEvent(this.email, this.password);
   @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

// State
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String email;
  const AuthAuthenticated(this.email);
   @override
  List<Object> get props => [email];
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
   @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
  }

  void _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    if (event.email.isNotEmpty && event.password.length >= 6) {
      emit(AuthAuthenticated(event.email));
    } else {
      emit(const AuthError('Signup failed. Check your details.'));
    }
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    if (event.email.isNotEmpty && event.password.length >= 6) {
      emit(AuthAuthenticated(event.email));
    } else {
      emit(const AuthError('Invalid credentials'));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}
