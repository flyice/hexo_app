import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hexo_app/repositories/auth_repository.dart';

import '../models/credentials.dart';

//Auth Event
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class InitializeAuth extends AuthEvent {}

class LoggedIn extends AuthEvent {
  LoggedIn(this.credential, this.token) : super([token, credential]);
  final String token;
  final LoginCredential credential;
}

class LoggedOut extends AuthEvent {}

//Auth State
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class AuthUninitialized extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  AuthCredential authCredential;

  Authenticated(this.authCredential);
}

class Unauthenticated extends AuthState {}

//Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : assert(authRepository != null);

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is InitializeAuth) {
      final credential = authRepository.getAuthCredential();
      yield credential != null ? Authenticated(credential) : Unauthenticated();
    }

    if (event is LoggedIn) {
      final credential = AuthCredential(event.credential.url, event.token);
      authRepository.persistAuthCredential(credential);
      yield Authenticated(credential);
    }

    if (event is LoggedOut) {
      authRepository.deleteAuthCredential();
      yield Unauthenticated();
    }
  }
}
