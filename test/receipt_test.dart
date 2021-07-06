import 'package:flutter_test/flutter_test.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';


void main() {
  DateTime date = DateTime(2021, 02, 28);
  List<Receipt> _receipts = [];

  setUp(() {
    ///Receipt data source mock
    _receipts.add( Receipt(
      id: 'idOne',
      title: 'titleOne',
      amount: 100,
      date: date,
      category: "categoryTest",
    )) ;
  });

  group('Test Receipt', () {
    test('Checks after getting added from data source', ()  {
      expect(_receipts.length, 1);
      expect(_receipts[0].id, "idOne");
      expect(_receipts[0].title, "titleOne");
      expect(_receipts[0].amount, 100);
      expect(_receipts[0].date, date);
      expect(_receipts[0].category, "categoryTest");
    });
  });

}