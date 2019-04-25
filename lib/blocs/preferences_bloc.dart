import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Prefereces event
abstract class PreferencesEvent extends Equatable {
  PreferencesEvent([List props = const []]) : super(props);

  @override
  String toString() => runtimeType.toString();
}

class InitializePreferences extends PreferencesEvent {}

//Preferences state
abstract class PreferencesState extends Equatable {
  PreferencesState([List props = const []]) : super(props);
  @override
  String toString() => runtimeType.toString();
}

class PreferencesUninitialized extends PreferencesState {}

class PreferencesLoaded extends PreferencesState {
  final SharedPreferences prefs;

  PreferencesLoaded({@required this.prefs})
      : assert(prefs != null),
        super([prefs]);
}

//Preferences bloc
class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  @override
  PreferencesState get initialState => PreferencesUninitialized();

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    if (event is InitializePreferences) {
      yield PreferencesLoaded(prefs: await SharedPreferences.getInstance());
    }
  }
}
