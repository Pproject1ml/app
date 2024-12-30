import 'package:chat_location/features/user/domain/entities/oauth_user.dart';
import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

enum AuthStateType { initial, authenticating, authenticated, unauthenticated }

abstract class AuthState extends Equatable {
  final AuthStateType state;

  const AuthState(this.state);

  @override
  List<Object?> get props => [state];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial() : super(AuthStateType.initial);
}

class AuthStateAuthenticating extends AuthState {
  final OauthUser? user;

  const AuthStateAuthenticating(this.user)
      : super(AuthStateType.authenticating);

  @override
  List<Object?> get props => [state, user];
}

class AuthStateAuthenticated extends AuthState {
  final AppUser user;

  const AuthStateAuthenticated(this.user) : super(AuthStateType.authenticated);

  @override
  List<Object?> get props => [state, user];
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated() : super(AuthStateType.unauthenticated);
}
