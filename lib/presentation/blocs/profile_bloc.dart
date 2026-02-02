import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

// State
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String avatarUrl;

  const ProfileLoaded({
    this.name = 'John Doe',
    this.email = 'john.doe@example.com',
    this.avatarUrl = 'assets/images/avatar_placeholder.png',
  });
  
  @override
  List<Object> get props => [name, email, avatarUrl];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const ProfileLoaded());
  }
}
