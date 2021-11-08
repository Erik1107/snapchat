import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class CountryCodeEvent extends Equatable {}

class CountryCodeChanged extends CountryCodeEvent {
  final String countryCode;

  final String id = Uuid().v1();
  CountryCodeChanged(this.countryCode);
  @override
  List<Object> get props => [id];
}

class CountryCodePageReloadFinish extends CountryCodeEvent {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}
