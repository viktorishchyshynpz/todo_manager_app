import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Перевірка статусу при запуску додатка
class AuthCheckRequested extends AuthEvent {}

/// Вхід через email/password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

/// Реєстрація
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

/// Вихід з системи
class AuthLogoutRequested extends AuthEvent {}

/// Перевірка, чи підтвердив користувач пошту (кнопка "Я підтвердив")
class AuthCheckVerificationStatus extends AuthEvent {}

/// Повторна відправка листа
class AuthResendVerificationEmail extends AuthEvent {}

/// Видалення акаунту (таймер вийшов або вихід з екрану верифікації)
class AuthDeleteAccountRequested extends AuthEvent {}