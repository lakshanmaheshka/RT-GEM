import 'package:flutter_test/flutter_test.dart';
import 'package:rt_gem/utils/grocery_models/grocery_model.dart';

void main() {
  DateTime manufacturedDate = DateTime(2021, 02, 28);
  DateTime expiryDate = DateTime(2021, 08, 28);
  List<Grocery> _groceries = [];

  setUp(() {
    ///Grocery data source mock
    _groceries.add( Grocery(
      productName: 'productName',
      quantity: 3,
      category: 'category',
      manufacturedDate: manufacturedDate,
      expiryDate: expiryDate,
      isConsumed: false,
    )) ;
  });

  group('Test Grocery', () {
    test('Checks after getting added from data source', ()  {
      expect(_groceries.length, 1);
      expect(_groceries[0].productName, "productName");
      expect(_groceries[0].quantity, 3);
      expect(_groceries[0].category, "category");
      expect(_groceries[0].manufacturedDate, manufacturedDate);
      expect(_groceries[0].expiryDate, expiryDate);
      expect(_groceries[0].isConsumed, false);
    });
  });

}