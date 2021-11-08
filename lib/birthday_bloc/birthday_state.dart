import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class BirthdayState extends Equatable {}

class BirthdayStateValid extends BirthdayState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class BirthdayStateInvalid extends BirthdayState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends BirthdayState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
