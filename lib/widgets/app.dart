import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexo_app/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/preferences_bloc.dart';
import 'home_page.dart';
import 'login.dart';
import 'splash.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _preferencesBloc = PreferencesBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hexo',
      home: BlocBuilder(
        bloc: _preferencesBloc,
        builder: (_, PreferencesState state) {
          if (state is PreferencesUninitialized) {
            _preferencesBloc.dispatch(InitializePreferences());
            return Splash();
          }

          if (state is PreferencesLoaded) {
            return HexoApp(prefs: state.prefs);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _preferencesBloc.dispose();
    super.dispose();
  }
}

class HexoApp extends StatefulWidget {
  final SharedPreferences prefs;

  HexoApp({Key key, @required this.prefs}) : super(key: key);

  @override
  _HexoAppState createState() => _HexoAppState();
}

class _HexoAppState extends State<HexoApp> {
  AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(AuthRepository(widget.prefs));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: BlocBuilder(
        bloc: _authBloc,
        builder: (_, AuthState state) {
          if (state is AuthUninitialized) {
            _authBloc.dispatch(InitializeAuth());
            return Splash();
          }
          if (state is AuthLoading) {
            return CircularProgressIndicator();
          }

          if (state is Authenticated) {
            return HomePage(state.authCredential);
          }

          if (state is Unauthenticated) {
            return Login();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }
}
