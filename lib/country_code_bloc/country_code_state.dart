import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class CountryCodeState extends Equatable {}

class CountryCodePageLoaded extends CountryCodeState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class CountryCodeAllState extends CountryCodeState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class CountryCodeSpecificState extends CountryCodeState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends CountryCodeState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
