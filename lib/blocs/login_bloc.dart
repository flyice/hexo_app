import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hexo_app/models/credentials.dart';
import 'package:hexo_app/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

import 'auth_bloc.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class LoginRequest extends LoginEvent {
  LoginRequest(this.credential) : super([credential]);

  final LoginCredential credential;
}

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({@required this.error}) : super([error]);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  LoginBloc(this.authBloc)
      : authRepository = authBloc.authRepository,
        assert(authBloc != null);

  LoginCredential getCredential() {
    return authRepository.getLoginCredential();
  }

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequest) {
      yield LoginLoading();

      try {
        final credential = event.credential;

        final token = await authRepository.auth(credential);
        authRepository.persistLoginCredential(credential);
        authBloc.dispatch(LoggedIn(credential, token));
      } on DioError catch (e) {
        final message = _handleDioError(e);
        yield LoginError(error: message);
      }
    }
  }

  String _handleDioError(DioError e) {
    if (e.response != null) {
      if (e.response.statusCode == 401 || e.response.statusCode == 400) {
        return 'Authenticate failed, please check username and password';
      }
      if (e.response.statusCode == 404) {
        return 'Invalid URL, please check it';
      }
    }
    return 'Network error';
  }
}
