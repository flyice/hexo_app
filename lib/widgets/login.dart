import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/login_bloc.dart';
import '../common/progress_hud.dart';
import '../models/credentials.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _credential;
  var _autovalidate = false;
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(BlocProvider.of<AuthBloc>(context));
    _credential = _loginBloc.getCredential() ?? LoginCredential();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _loginBloc,
      builder: (context, LoginState state) {
        if (state is LoginError) {
          _showInSnackBar(state.error);
        }
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            bottom: false,
            child: ProgressHUD(
              inAsyncCall: state is LoginLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    _buildLogo(),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: _buildForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _loginBloc.dispatch(LoginRequest(_credential));
    }
  }

  String _validateUrl(String value) {
    if (value.trim().isEmpty) return 'URL is required';

    final RegExp urlExp = RegExp(
        r"^(?:http(s)?:\/\/)[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$");
    if (!urlExp.hasMatch(value)) return 'Not a valid URL';
    return null;
  }

  String _validateUserName(String value) {
    if (value.trim().isEmpty) return 'Username is required';

    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';

    return null;
  }

  String _validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'password is required';
    }
    return null;
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'URL'),
            keyboardType: TextInputType.url,
            initialValue: _credential._url,
            onSaved: (value) => _credential._url = value,
            validator: _validateUrl,
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: InputDecoration(labelText: 'USERNAME'),
            initialValue: _credential.username,
            onSaved: (value) => _credential.username = value,
            validator: _validateUserName,
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: InputDecoration(labelText: 'PASSWORD'),
            obscureText: true,
            initialValue: _credential.password,
            onSaved: (value) => _credential.password = value,
            validator: _validatePassword,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 25),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Login'),
              onPressed: _handleSubmitted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
      child: SvgPicture.asset(
        'assets/images/hexo_logo.svg',
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
