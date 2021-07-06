import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rt_gem/utils/custom_colors.dart';

List<String> receiptCategories = [
  'Grocery',
  'Health',
  'Electronic Goods',
  'Mobile',
  'Apparel',
  'Gift',
  'Education',
  'Entertainment',
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



    case "Bread/Bakery": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/BreadBakery.png"));
    }


    case "Dairy Products": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/DairyProducts.png"));
    }


    case "Cereals": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/cereals.png"));
    }


    case "Canned Foods": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/CannedFoods.png"));
    }


    case "Frozen Foods": {
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/FrozenFoods.png"));
    }


    case 'Snack Foods':
      return SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/images/SnackFoods.png"));



    case "Others": {
      return SizedBox(
          width: 65,
          height: 65,
          child: Image.asset("assets/images/others.png"));
    }



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



    case "Bread/Bakery": {
      return  <HexColor>[
        HexColor('#fc4a1a'),
        HexColor('#f7b733'),
      ];
    }


    case "Dairy Products": {
      return  <HexColor>[
        HexColor('#f7ff00'),
        HexColor('#db36a4'),
      ];
    }


    case "Cereals": {
      return  <HexColor>[
        HexColor('#d53369'),
        HexColor('#cbad6d'),
      ];
    }


    case "Canned Foods": {
      return  <HexColor>[
        HexColor('#f857a6'),
        HexColor('#ff5858'),
      ];
    }


    case "Frozen Foods": {
      return  <HexColor>[
        HexColor('#2193b0'),
        HexColor('#6dd5ed'),
      ];
    }


    case 'Snack Foods':
    //statements;
      return  <HexColor>[
        HexColor('#FC5C7D'),
        HexColor('#6A82FB'),
      ];



    case "Others": {
      return  <HexColor>[
        HexColor('#11998e'),
        HexColor('#38ef7d'),
      ];
    }



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

DateTime? convertToDate(String input) {
  try {
    var d = dateFormatS.parseStrict(input);
    return d;
  } catch (e) {
    return null;
  }
}



