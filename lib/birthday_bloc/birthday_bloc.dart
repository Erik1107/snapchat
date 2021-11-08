import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/validation_repository.dart';
import 'birthday_event.dart';
import 'birthday_state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc(this.validationRepository) : super(BirthdayStateValid());
  final ValidationRepository validationRepository;
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
  HttpService httpService = HttpService();
  @override
  Stream<BirthdayState> mapEventToState(BirthdayEvent event) async* {
    if (event is BirthdayDateChanged) {
      var dateTime = event.birthdayDate.millisecondsSinceEpoch;
      var now = event.nowDate.millisecondsSinceEpoch;

      _dateTime = DateTime.fromMillisecondsSinceEpoch(
          now - (16 * 36525 * 24 * 60 * 60 * 10));

      if (validationRepository.birthdayValidation(dateTime, now)) {
        yield BirthdayStateValid();
      } else {
        yield BirthdayStateInvalid();
      }
    }
  }
}
