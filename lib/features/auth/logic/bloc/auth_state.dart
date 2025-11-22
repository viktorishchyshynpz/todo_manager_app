import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  initial,      // Сплеш скрін
  loading,      // Спінер
  authenticated, // Увійшов і пошта підтверджена
  unauthenticated, // Не увійшов
  unverified,    // Увійшов, але пошта НЕ підтверджена (для екрану верифікації)
  failure,       // Помилка
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? infoMessage; // Наприклад "Лист відправлено"

  const AuthState._({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.infoMessage,
  });

  const AuthState.initial() : this._();

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.unverified(User user)
      : this._(status: AuthStatus.unverified, user: user);

  const AuthState.failure(String message)
      : this._(status: AuthStatus.failure, errorMessage: message);

  // Спеціальний стан, щоб показати повідомлення без зміни основного статусу
  // Ми будемо використовувати copyWith для цього в блоці
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? infoMessage,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage, // Помилки скидаються при новому стані, якщо не передані
      infoMessage: infoMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, infoMessage];
}