import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rt_gem/utils/custom_colors.dart';

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


Widget getCategoryImage(String currentCategory) {
  switch(currentCategory){
    case "Beverages":
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/Beverages.png"));

      break;

    case "Bread/Bakery": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/BreadBakery.png"));
    }
    break;

    case "Dairy Products": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/DairyProducts.png"));
    }
    break;

    case "Cereals": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/cereals.png"));
    }
    break;

    case "Canned Foods": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/CannedFoods.png"));
    }
    break;

    case "Frozen Foods": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/FrozenFoods.png"));
    }
    break;

    case 'Snack Foods':
    //statements;
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/SnackFoods.png"));

      break;

    case "Others": {
      return SizedBox(
          width: 65,
          height: 65,
          child: Image.asset("assets/images/others.png"));
    }
    break;


    default: {
      return SizedBox(
          width: 65,
          height: 65,
          child: Image.asset("assets/images/others.png"));
    }

  }
}


List<HexColor> getCategoryColor(String currentCategory) {
  switch(currentCategory){
    case "Beverages":
      return <HexColor>[
        HexColor('#FA7D82'),
        HexColor('#FFB295'),
      ];

      break;

    case "Bread/Bakery": {
      return  <HexColor>[
        HexColor('#fc4a1a'),
        HexColor('#f7b733'),
      ];
    }
    break;

    case "Dairy Products": {
      return  <HexColor>[
        HexColor('#f7ff00'),
        HexColor('#db36a4'),
      ];
    }
    break;

    case "Cereals": {
      return  <HexColor>[
        HexColor('#d53369'),
        HexColor('#cbad6d'),
      ];
    }
    break;

    case "Canned Foods": {
      return  <HexColor>[
        HexColor('#f857a6'),
        HexColor('#ff5858'),
      ];
    }
    break;

    case "Frozen Foods": {
      return  <HexColor>[
        HexColor('#2193b0'),
        HexColor('#6dd5ed'),
      ];
    }
    break;

    case 'Snack Foods':
    //statements;
      return  <HexColor>[
        HexColor('#FC5C7D'),
        HexColor('#6A82FB'),
      ];

      break;

    case "Others": {
      return  <HexColor>[
        HexColor('#11998e'),
        HexColor('#38ef7d'),
      ];
    }
    break;


    default: {
      return  <HexColor>[
        HexColor('#11998e'),
        HexColor('#38ef7d'),
      ];
    }

  }
}


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

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}



