import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

List<String> receiptCategories = [
  'Food',
  'Social Life',
  'Self-development',
  'Transportation',
  'Culture',
  'Household',
  'Apparel',
  'Beauty',
  'Health',
  'Education',
  'Gift',
  'Other',
];


List<String> groceryCategories = [
  'Beverages',
  'Bread/Bakery',
  'Dairy Products',
  'Cereals',
  'Canned Foods',
  'Frozen Foods',
  'Snack Foods',
  'Others'
];


final  DateFormat dateFormatS = new DateFormat("dd-MM-yyyy");

/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}


/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

/// Find first date of the month which contains provided date.
DateTime findFirstDateOfTheMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, 1);
}

/// Find last date of the month which contains provided date.
DateTime findLastDateOfTheMonth(DateTime dateTime) {
  return  Jiffy(DateTime(dateTime.year, dateTime.month, 1)).add(months: 1).add(days: -1).dateTime;
}


bool sameDate(DateTime dateOne, DateTime dateTwo ){
  return dateOne.day == dateTwo.day && dateOne.month == dateTwo.month && dateOne.year ==dateTwo.year;
}

bool isNextDate(DateTime dateOne, DateTime dateTwo ){
  return dateOne.day == dateTwo.day + 1 && dateOne.month == dateTwo.month && dateOne.year ==dateTwo.year;
}



