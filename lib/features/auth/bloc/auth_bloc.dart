import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spend_wise/features/auth/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(authLoginEvent);
    on<AuthRegisterEvent>(authRegisterEvent);
  }

  Future<FutureOr<void>> authLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final bool success =
          await AuthRepo.loginUser(event.email, event.password, event.context);
      if (success) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState('Login failed'));
      }
    } catch (err) {
      emit(AuthErrorState('Login failed: $err'));
    }
  }

  FutureOr<void> authRegisterEvent(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final bool success = await AuthRepo.registerUser(
          event.name, event.email, event.password, event.context);
      if (success) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState('Registration failed'));
      }
    } catch (err) {
      emit(AuthErrorState('Registration failed: $err'));
    }
  }
}
