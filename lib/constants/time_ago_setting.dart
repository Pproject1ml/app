import 'package:intl/intl.dart';
import 'package:timeago/src/messages/lookupmessages.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Korean messages
class CustomKoMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '지금부터';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '후';
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String aboutAMinute(int minutes) => '1분';
  @override
  String minutes(int minutes) => '${minutes}분';
  @override
  String aboutAnHour(int minutes) => '1시간';
  @override
  String hours(int hours) => '${hours}시간';
  @override
  String aDay(int hours) => '1일';
  @override
  String days(int days) => '${days}일';
  @override
  String aboutAMonth(int days) => '1달';
  @override
  String months(int months) => '${months}달';
  @override
  String aboutAYear(int year) => '1년';
  @override
  String years(int years) => '${years}년';
  @override
  String wordSeparator() => ' ';
}

String formatCustomTime(DateTime dateTime) {
  final now = DateTime.now();
  final differenceInDays = now.difference(dateTime).inDays;

  if (differenceInDays < 7) {
    // 7일 이내: 날짜 표시
    return DateFormat('M월 d일').format(dateTime);
  } else {
    // 7일 이후: timeago 사용
    return timeago.format(dateTime, locale: 'ko');
  }
}
