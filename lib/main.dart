import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'common/simple_bloc_delegate.dart';
import 'widgets/app.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  runApp(App());
}
