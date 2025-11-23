import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial()) {

    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckVerificationStatus>(_onCheckVerificationStatus);
    on<AuthResendVerificationEmail>(_onResendVerificationEmail);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);

    // Слухаємо зміни стрима Firebase
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthCheckRequested());
    });
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = _authRepository.currentUser;

    if (user != null) {
      try {
        await _authRepository.reloadUser();
      } catch (_) {
      }

      if (user.emailVerified) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unverified(user));
      }
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signIn(email: event.email, password: event.password);
      // Стан оновиться автоматично через listener (_authSubscription) -> AuthCheckRequested
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signUp(email: event.email, password: event.password);
      await _authRepository.sendVerificationEmail();
      // Після успішної реєстрації Firebase автоматично логінить юзера,
      // тому спрацює listener, і ми перейдемо в стан unverified
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _authRepository.signOut();
  }

  // Перевірка пошти (кнопка "Я підтвердив")
  Future<void> _onCheckVerificationStatus(
      AuthCheckVerificationStatus event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.reloadUser();
      if (user != null && user.emailVerified) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unverified(user!));
        // Можна додати infoMessage: "Пошта ще не підтверджена"
        emit(state.copyWith(errorMessage: 'email-not-verified'));
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onResendVerificationEmail(
      AuthResendVerificationEmail event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.sendVerificationEmail();
      emit(state.copyWith(infoMessage: 'verification-email-sent'));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteAccountRequested(
      AuthDeleteAccountRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.deleteUnverifiedAccount();
      // Після видалення Firebase стрим спрацює і переведе в unauthenticated
    } catch (e) {
      // Якщо помилка requires-recent-login, просто робимо вихід
      if (e.toString().contains('requires-recent-login')) {
        await _authRepository.signOut();
      } else {
        emit(AuthState.failure(e.toString()));
        // Примусовий вихід, щоб не застрягнути
        await _authRepository.signOut();
      }
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}