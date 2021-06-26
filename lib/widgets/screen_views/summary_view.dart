
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/utils/grocery_models/grocery_model.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';

class SummaryView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  const SummaryView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {

  late String expires ="All";

  late int itemsUsed = 0;
  late int itemsAdded = 0;

  late double itemsLeftBeverages = 0.0;
  late double itemsLeftBread = 0.0;
  late double itemsLeftDairy = 0.0;
  late double itemsLeftCereals = 0.0;
  late double itemsLeftCanned = 0.0;
  late double itemsLeftFrozen = 0.0;
  late double itemsLeftSnack = 0.0;
  late double itemsLeftOthers = 0.0;

  late double itemsTotalBeverages = 0.1;
  late double itemsTotalBread = 0.1;
  late double itemsTotalDairy = 0.1;
  late double itemsTotalCereals = 0.1;
  late double itemsTotalCanned = 0.1;
  late double itemsTotalFrozen = 0.1;
  late double itemsTotalSnack = 0.1;
  late double itemsTotalOthers = 0.1;

  void getProducts () async {
    List<Grocery> _groceries = [];

    List<Grocery> _filteredBeverages = [];
    List<Grocery> _filteredBread = [];
    List<Grocery> _filteredDairy = [];
    List<Grocery> _filteredCereals = [];
    List<Grocery> _filteredCanned = [];
    List<Grocery> _filteredFrozen = [];
    List<Grocery> _filteredSnack = [];
    List<Grocery> _filteredOthers = [];

    final fetchedData = await Database.getGroceryData();
    DateTime date = DateTime.now();

    _groceries = fetchedData
        .map(
          (item) => Grocery(
        productName: item['productName'],
        quantity: item['quantity'],
        category: item['category'],
        manufacturedDate: item['manufacturedDate'].toDate(),
        expiryDate: item['expiryDate'].toDate(),
        isConsumed: item['isConsumed'],
      ),
    )
        .toList();

    switch (Globaldata.filter.value) {
      case 0:

        if (this.mounted) {
          setState(() {
            expires = "All";
          });
        }

        List<Grocery> _filteredGroceries = [];

        _groceries.forEach((element) {
            _filteredGroceries.add(element);
        });

        if (this.mounted) {
          setState(() {
            itemsAdded = _filteredGroceries.length;
          });
        }

        _filteredGroceries = [];

        _groceries.forEach((element) {
          if(element.isConsumed != null && element.isConsumed == true ){
            _filteredGroceries.add(element);
          }
        });

        if (this.mounted) {
        setState(() {
          itemsUsed = _filteredGroceries.length;
        });
        }

        _filteredGroceries = [];

        _groceries.forEach((element) {
          if(element.isConsumed != null && element.isConsumed == true ){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsUsed = _filteredGroceries.length;
        });
        }

        _filteredGroceries = [];


        _groceries.forEach((element) {
            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
              break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;

              default :
                _filteredOthers.add(element);
            }
        });
        if (this.mounted) {
        setState(() {
          itemsTotalBeverages = _filteredBeverages.length.toDouble() == 0.0 ? 0.1 : _filteredBeverages.length.toDouble();
          itemsTotalBread = _filteredBread.length.toDouble() == 0.0 ? 0.1 : _filteredBread.length.toDouble();
          itemsTotalDairy = _filteredDairy.length.toDouble() == 0.0 ? 0.1 : _filteredDairy.length.toDouble();
          itemsTotalCereals = _filteredCereals.length.toDouble() == 0.0 ? 0.1 : _filteredCereals.length.toDouble();
          itemsTotalCanned = _filteredCanned.length.toDouble() == 0.0 ? 0.1 : _filteredCanned.length.toDouble();
          itemsTotalFrozen = _filteredFrozen.length.toDouble() == 0.0 ? 0.1 : _filteredFrozen.length.toDouble();
          itemsTotalSnack = _filteredSnack.length.toDouble() == 0.0 ? 0.1 : _filteredSnack.length.toDouble();
          itemsTotalOthers = _filteredOthers.length.toDouble() == 0.0 ? 0.1 : _filteredOthers.length.toDouble();
        });
        }

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        _groceries.forEach((element) {

          if(element.isConsumed != null && element.isConsumed == false){

            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;
              default :
                _filteredOthers.add(element);

            }

          }
        });
        if (this.mounted) {
          setState(() {
            itemsLeftBeverages = _filteredBeverages.length.toDouble();
            itemsLeftBread = _filteredBread.length.toDouble();
            itemsLeftDairy = _filteredDairy.length.toDouble();
            itemsLeftCereals = _filteredCereals.length.toDouble();
            itemsLeftCanned = _filteredCanned.length.toDouble();
            itemsLeftFrozen = _filteredFrozen.length.toDouble();
            itemsLeftSnack = _filteredSnack.length.toDouble();
            itemsLeftOthers = _filteredOthers.length.toDouble();
          });
        }

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];

        break;
      case 1:
        if (this.mounted) {
        setState(() {
          expires = "This Day";
        });
        }

        List<Grocery> _filteredGroceries = [];

        _groceries.forEach((element) {
          if(sameDate(element.expiryDate!, date)){
            _filteredGroceries.add(element);
          }
        });

        if (this.mounted) {
          setState(() {
            itemsAdded = _filteredGroceries.length;
          });
        }

        _filteredGroceries = [];


        _groceries.forEach((element) {
          if(sameDate(element.expiryDate!, date)){
            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;

              default :
                _filteredOthers.add(element);
            }
          }



        });
        if (this.mounted) {
        setState(() {
          itemsTotalBeverages = _filteredBeverages.length.toDouble() == 0.0 ? 0.1 : _filteredBeverages.length.toDouble();
          itemsTotalBread = _filteredBread.length.toDouble() == 0.0 ? 0.1 : _filteredBread.length.toDouble();
          itemsTotalDairy = _filteredDairy.length.toDouble() == 0.0 ? 0.1 : _filteredDairy.length.toDouble();
          itemsTotalCereals = _filteredCereals.length.toDouble() == 0.0 ? 0.1 : _filteredCereals.length.toDouble();
          itemsTotalCanned = _filteredCanned.length.toDouble() == 0.0 ? 0.1 : _filteredCanned.length.toDouble();
          itemsTotalFrozen = _filteredFrozen.length.toDouble() == 0.0 ? 0.1 : _filteredFrozen.length.toDouble();
          itemsTotalSnack = _filteredSnack.length.toDouble() == 0.0 ? 0.1 : _filteredSnack.length.toDouble();
          itemsTotalOthers = _filteredOthers.length.toDouble() == 0.0 ? 0.1 : _filteredOthers.length.toDouble();

        });
        }

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        _groceries.forEach((element) {

          if(element.isConsumed != null && element.isConsumed == false && sameDate(element.expiryDate!, date)){

            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;
              default :
                _filteredOthers.add(element);

            }

          }
        });
        if (this.mounted) {
        setState(() {
          itemsLeftBeverages = _filteredBeverages.length.toDouble();
          itemsLeftBread = _filteredBread.length.toDouble();
          itemsLeftDairy = _filteredDairy.length.toDouble();
          itemsLeftCereals = _filteredCereals.length.toDouble();
          itemsLeftCanned = _filteredCanned.length.toDouble();
          itemsLeftFrozen = _filteredFrozen.length.toDouble();
          itemsLeftSnack = _filteredSnack.length.toDouble();
          itemsLeftOthers = _filteredOthers.length.toDouble();
        });
        }

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        break;
      case 2:
        if (this.mounted) {
        setState(() {
          expires = "Tomorrow";
        });}

        List<Grocery> _filteredGroceries = [];

        _groceries.forEach((element) {
          if(isNextDate(element.expiryDate!, date)){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsAdded = _filteredGroceries.length;
        });}

        _filteredGroceries = [];

        _groceries.forEach((element) {
          if(element.isConsumed != null && element.isConsumed == true && isNextDate(element.expiryDate!, date)){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsUsed = _filteredGroceries.length;
        });}

        _filteredGroceries = [];



        _groceries.forEach((element) {
          if(isNextDate(element.expiryDate!, date)){
            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;

              default :
                _filteredOthers.add(element);
            }
          }



        });
        if (this.mounted) {
        setState(() {
          itemsTotalBeverages = _filteredBeverages.length.toDouble() == 0.0 ? 0.1 : _filteredBeverages.length.toDouble();
          itemsTotalBread = _filteredBread.length.toDouble() == 0.0 ? 0.1 : _filteredBread.length.toDouble();
          itemsTotalDairy = _filteredDairy.length.toDouble() == 0.0 ? 0.1 : _filteredDairy.length.toDouble();
          itemsTotalCereals = _filteredCereals.length.toDouble() == 0.0 ? 0.1 : _filteredCereals.length.toDouble();
          itemsTotalCanned = _filteredCanned.length.toDouble() == 0.0 ? 0.1 : _filteredCanned.length.toDouble();
          itemsTotalFrozen = _filteredFrozen.length.toDouble() == 0.0 ? 0.1 : _filteredFrozen.length.toDouble();
          itemsTotalSnack = _filteredSnack.length.toDouble() == 0.0 ? 0.1 : _filteredSnack.length.toDouble();
          itemsTotalOthers = _filteredOthers.length.toDouble() == 0.0 ? 0.1 : _filteredOthers.length.toDouble();

        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        _groceries.forEach((element) {

          if(element.isConsumed != null && element.isConsumed == false && isNextDate(element.expiryDate!, date)){

            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;
              default :
                _filteredOthers.add(element);

            }

          }
        });
        if (this.mounted) {
        setState(() {
          itemsLeftBeverages = _filteredBeverages.length.toDouble();
          itemsLeftBread = _filteredBread.length.toDouble();
          itemsLeftDairy = _filteredDairy.length.toDouble();
          itemsLeftCereals = _filteredCereals.length.toDouble();
          itemsLeftCanned = _filteredCanned.length.toDouble();
          itemsLeftFrozen = _filteredFrozen.length.toDouble();
          itemsLeftSnack = _filteredSnack.length.toDouble();
          itemsLeftOthers = _filteredOthers.length.toDouble();
        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        break;

      case 3:
        if (this.mounted) {
        setState(() {
          expires = "This Week";
        });}

        List<Grocery> _filteredGroceries = [];

        _groceries.forEach((element) {
          if((element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || sameDate(element.expiryDate!, date)  )
              && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsAdded = _filteredGroceries.length;
        });}

        _filteredGroceries = [];

        _groceries.forEach((element) {
          if(element.isConsumed != null && element.isConsumed == true
              && (element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )
              && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsUsed = _filteredGroceries.length;
        });}

        _filteredGroceries = [];


        _groceries.forEach((element) {
          if((element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )
              && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )){
            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;

              default :
                _filteredOthers.add(element);
            }
          }



        });
        if (this.mounted) {
        setState(() {
          itemsTotalBeverages = _filteredBeverages.length.toDouble() == 0.0 ? 0.1 : _filteredBeverages.length.toDouble();
          itemsTotalBread = _filteredBread.length.toDouble() == 0.0 ? 0.1 : _filteredBread.length.toDouble();
          itemsTotalDairy = _filteredDairy.length.toDouble() == 0.0 ? 0.1 : _filteredDairy.length.toDouble();
          itemsTotalCereals = _filteredCereals.length.toDouble() == 0.0 ? 0.1 : _filteredCereals.length.toDouble();
          itemsTotalCanned = _filteredCanned.length.toDouble() == 0.0 ? 0.1 : _filteredCanned.length.toDouble();
          itemsTotalFrozen = _filteredFrozen.length.toDouble() == 0.0 ? 0.1 : _filteredFrozen.length.toDouble();
          itemsTotalSnack = _filteredSnack.length.toDouble() == 0.0 ? 0.1 : _filteredSnack.length.toDouble();
          itemsTotalOthers = _filteredOthers.length.toDouble() == 0.0 ? 0.1 : _filteredOthers.length.toDouble();

        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        _groceries.forEach((element) {

          if(element.isConsumed != null
              && element.isConsumed == false
              && (element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )
              && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || sameDate(element.expiryDate!, date) )){

            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;
              default :
                _filteredOthers.add(element);

            }

          }
        });
        if (this.mounted) {
        setState(() {
          itemsLeftBeverages = _filteredBeverages.length.toDouble();
          itemsLeftBread = _filteredBread.length.toDouble();
          itemsLeftDairy = _filteredDairy.length.toDouble();
          itemsLeftCereals = _filteredCereals.length.toDouble();
          itemsLeftCanned = _filteredCanned.length.toDouble();
          itemsLeftFrozen = _filteredFrozen.length.toDouble();
          itemsLeftSnack = _filteredSnack.length.toDouble();
          itemsLeftOthers = _filteredOthers.length.toDouble();
        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        break;
      case 4:
        if (this.mounted) {
        setState(() {
          expires = "This Month";
        });}


        List<Grocery> _filteredGroceries = [];

        _groceries.forEach((element) {
          if((element.expiryDate!.isAfter(findFirstDateOfTheMonth(date)) || sameDate(element.expiryDate!, date)  )
              && (element.expiryDate!.isBefore(findLastDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsAdded = _filteredGroceries.length;
        });}

        _filteredGroceries = [];

        _groceries.forEach((element) {
          if(element.isConsumed != null && element.isConsumed == true
              && (element.expiryDate!.isAfter(findFirstDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))
              && (element.expiryDate!.isBefore(findLastDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))){
            _filteredGroceries.add(element);
          }
        });
        if (this.mounted) {
        setState(() {
          itemsUsed = _filteredGroceries.length;
        });}

        _filteredGroceries = [];


        _groceries.forEach((element) {
          if((element.expiryDate!.isAfter(findFirstDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))
              && (element.expiryDate!.isBefore(findLastDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))){
            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;

              default :
                _filteredOthers.add(element);
            }
          }



        });
        if (this.mounted) {
        setState(() {
          itemsTotalBeverages = _filteredBeverages.length.toDouble() == 0.0 ? 0.1 : _filteredBeverages.length.toDouble();
          itemsTotalBread = _filteredBread.length.toDouble() == 0.0 ? 0.1 : _filteredBread.length.toDouble();
          itemsTotalDairy = _filteredDairy.length.toDouble() == 0.0 ? 0.1 : _filteredDairy.length.toDouble();
          itemsTotalCereals = _filteredCereals.length.toDouble() == 0.0 ? 0.1 : _filteredCereals.length.toDouble();
          itemsTotalCanned = _filteredCanned.length.toDouble() == 0.0 ? 0.1 : _filteredCanned.length.toDouble();
          itemsTotalFrozen = _filteredFrozen.length.toDouble() == 0.0 ? 0.1 : _filteredFrozen.length.toDouble();
          itemsTotalSnack = _filteredSnack.length.toDouble() == 0.0 ? 0.1 : _filteredSnack.length.toDouble();
          itemsTotalOthers = _filteredOthers.length.toDouble() == 0.0 ? 0.1 : _filteredOthers.length.toDouble();

        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        _groceries.forEach((element) {

          if(element.isConsumed != null
              && element.isConsumed == false
              && (element.expiryDate!.isAfter(findFirstDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))
              && (element.expiryDate!.isBefore(findLastDateOfTheMonth(date)) || sameDate(element.expiryDate!, date))){

            switch (element.category) {
              case "Beverages":
                _filteredBeverages.add(element);
                break;
              case "Bread/Bakery":
                _filteredBread.add(element);
                break;
              case "Dairy Products":
                _filteredDairy.add(element);
                break;
              case "Cereals":
                _filteredCereals.add(element);
                break;
              case "Canned Foods":
                _filteredCanned.add(element);
                break;
              case "Frozen Foods":
                _filteredFrozen.add(element);
                break;
              case "Snack Foods":
                _filteredSnack.add(element);
                break;
              case "Others":
                _filteredOthers.add(element);
                break;
              default :
                _filteredOthers.add(element);

            }

          }
        });
        if (this.mounted) {
        setState(() {
          itemsLeftBeverages = _filteredBeverages.length.toDouble();
          itemsLeftBread = _filteredBread.length.toDouble();
          itemsLeftDairy = _filteredDairy.length.toDouble();
          itemsLeftCereals = _filteredCereals.length.toDouble();
          itemsLeftCanned = _filteredCanned.length.toDouble();
          itemsLeftFrozen = _filteredFrozen.length.toDouble();
          itemsLeftSnack = _filteredSnack.length.toDouble();
          itemsLeftOthers = _filteredOthers.length.toDouble();
        });}

        _filteredBeverages = [];
        _filteredBread = [];
        _filteredDairy = [];
        _filteredCereals = [];
        _filteredCanned = [];
        _filteredFrozen = [];
        _filteredSnack = [];
        _filteredOthers = [];


        break;
      default:
        expires = "All";
    }
  }


  @override
  void initState() {
    Globaldata.filter.value = 0;
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation as Animation<double>,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 16, bottom: 18),
              child: ValueListenableBuilder(
                valueListenable: Globaldata.stateChanged,
                builder: (BuildContext context, value, Widget? child) {
                  getProducts();
                  return InkWell(
                    onTap: (){
                      if (this.mounted) {
                      setState(() {
                        Globaldata.filter.value++;
                        if(Globaldata.filter.value > 4){
                          Globaldata.filter.value = 0;
                        }
                        getProducts();
                      }
                      );}
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[

                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#87A0E5')
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 2),
                                                    child: Text(
                                                      'Items Added',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        letterSpacing: -0.1,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 28,
                                                        height: 28,
                                                        child: Image.asset(
                                                            "assets/images/AddedItems.png"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          '${(itemsAdded * widget.animation!.value).toInt()}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 16,
                                                            color: AppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#00FF00')
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 4, bottom: 2),
                                                    child: Text(
                                                      'Items Used',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        AppTheme.fontName,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: kIsWeb ? 16 : 14,
                                                        letterSpacing: -0.1,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 28,
                                                        height: 28,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(3.0),
                                                          child: Image.asset(
                                                              "assets/images/checked.png"),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                        child: Text(
                                                          '${(itemsUsed * widget.animation!.value).toInt()}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 16,
                                                            color: AppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: Stack(
                                      clipBehavior: Clip.none, children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: AppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100.0),
                                            ),
                                            border: new Border.all(
                                                width: 4,
                                                color: AppTheme
                                                    .nearlyDarkBlue
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${((itemsAdded - itemsUsed)  * widget.animation!.value).toInt()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                  AppTheme.fontName,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 24,
                                                  letterSpacing: 0.0,
                                                  color: AppTheme
                                                      .nearlyDarkBlue,
                                                ),
                                              ),
                                              Text(
                                                'Items left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                  AppTheme.fontName,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  letterSpacing: 0.0,
                                                  color: AppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CustomPaint(
                                          painter: CurvePainter(
                                              colors: [
                                                AppTheme.nearlyDarkBlue,
                                                HexColor("#8A98E8"),
                                                HexColor("#8A98E8")
                                              ],
                                              angle: itemsAdded == 0 ?   (0 +
                                                  (1.0 - widget.animation!.value)) :
                                              (340/itemsAdded) * (itemsAdded - itemsUsed)+
                                                  (1.0 - widget.animation!.value)),
                                          child: SizedBox(
                                            width: 108,
                                            height: 108,
                                          ),
                                        ),
                                      )
                                    ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                expires,

                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: AppTheme.grey
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 8),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              ' \nBeverages',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color:
                                                  HexColor('#FA7D82').withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: (((70 /
                                                          itemsTotalBeverages) * itemsLeftBeverages) * widget.animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#FA7D82'),
                                                          HexColor('#FFB295')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '$itemsLeftBeverages left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.grey.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Bread/\nBakery',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color:
                                                  HexColor('#fc4a1a').withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: (((70 /
                                                          itemsTotalBread) * itemsLeftBread) * widget.animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#fc4a1a'),
                                                          HexColor('#f7b733')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '$itemsLeftBread left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.grey.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Dairy\nProducts',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#f7ff00')
                                                      .withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: (((70 /
                                                          itemsTotalDairy) * itemsLeftDairy) *
                                                          widget.animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#f7ff00')
                                                              .withOpacity(0.1),
                                                          HexColor('#db36a4'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '$itemsLeftDairy left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  ' \nCereals',
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: -0.2,
                                                    color: AppTheme.darkText,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 0, top: 4),
                                                  child: Container(
                                                    height: 4,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#d53369')
                                                          .withOpacity(0.2),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: (((70 /
                                                              itemsTotalCereals) * itemsLeftCereals) *
                                                              widget.animationController!.value),
                                                          height: 4,
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                            LinearGradient(colors: [
                                                              HexColor('#d53369')
                                                                  .withOpacity(0.1),
                                                              HexColor('#cbad6d'),
                                                            ]),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(4.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    '$itemsLeftCereals left',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Canned\nFoods',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: -0.2,
                                              color: AppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color:
                                                HexColor('#f857a6').withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: (((70 /
                                                        itemsTotalCanned) * itemsLeftCanned) * widget.animation!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(colors: [
                                                        HexColor('#f857a6'),
                                                        HexColor('#ff5858')
                                                            .withOpacity(0.5),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '$itemsLeftCanned left',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color:
                                                AppTheme.grey.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Frozen\nFoods',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: -0.2,
                                              color: AppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color:
                                                HexColor('#87A0E5').withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: (((70 /
                                                        itemsTotalFrozen) * itemsLeftFrozen) * widget.animation!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(colors: [
                                                        HexColor('#2193b0'),
                                                        HexColor('#6dd5ed')
                                                            .withOpacity(0.5),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '$itemsLeftFrozen left',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color:
                                                AppTheme.grey.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Snack\nFoods',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: -0.2,
                                              color: AppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: HexColor('#FC5C7D')
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: (((70 /
                                                        itemsTotalSnack) * itemsLeftSnack) *
                                                        widget.animationController!.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(colors: [
                                                        HexColor('#FC5C7D')
                                                            .withOpacity(0.1),
                                                        HexColor('#6A82FB'),
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '$itemsLeftSnack left',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: AppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                ' \nOthers',
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0, top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#11998e')
                                                        .withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: (((70 /
                                                            itemsTotalOthers) * itemsLeftOthers) *
                                                            widget.animationController!.value),
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                          LinearGradient(colors: [
                                                            HexColor('#11998e')
                                                                .withOpacity(0.1),
                                                            HexColor('#38ef7d'),
                                                          ]),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(4.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: Text(
                                                  '$itemsLeftOthers left',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}



class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color>? colorsList = <Color>[];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList!,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
