import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class BirthdayEvent extends Equatable {}

class BirthdayDateChanged extends BirthdayEvent {
  final DateTime birthdayDate;
  final DateTime nowDate;
  BirthdayDateChanged(this.birthdayDate, this.nowDate);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
