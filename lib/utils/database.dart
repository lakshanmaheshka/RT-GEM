import 'package:cloud_firestore/cloud_firestore.dart';

import 'commons.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('rt_gem');

class Database {
  static String? userUid;

  static Future<void> addGrocery({
    required String productName,
    required int quantity,
    required String category,
    required DateTime manufacturedDate,
    required DateTime expiryDate,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "productName": productName,
      "quantity": quantity,
      "category": category,
      "manufacturedDate": manufacturedDate,
      "expiryDate": expiryDate,
      "isConsumed": false
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Grocery item added to the database"))
        .catchError((e) => print(e));
  }


  static Future<void> addReceipt({
    required String id,
    required String receiptName,
    required int amount,
    required String category,
    required String addedDate,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('receipts').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "receiptName": receiptName,
      "amount": amount,
      "category": category,
      "addedDate": addedDate,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Receipt added to the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readGroceries() {
    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');

    final Query readAll = collectionReference
        .where("isConsumed", isEqualTo: false)
        .orderBy("expiryDate");

    return readAll.snapshots();
  }

  static Stream<QuerySnapshot> readGroceriesByDay() {
    DateTime date = DateTime.now();


    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');

    final Query byWeek = collectionReference
        .where("isConsumed", isEqualTo: false)
        .where("expiryDate", isLessThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .where("expiryDate", isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day));


    return byWeek.snapshots();
  }

  static Stream<QuerySnapshot> readGroceriesByNextDay() {
    DateTime date = DateTime.now();


    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');

    final Query byWeek = collectionReference
        .where("isConsumed", isEqualTo: false)
        .where("expiryDate", isLessThanOrEqualTo: DateTime(date.year, date.month, date.day+1))
        .where("expiryDate", isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day+1));


    return byWeek.snapshots();
  }

  static Stream<QuerySnapshot> readGroceriesByWeek() {
    DateTime date = DateTime.now();


    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');

    final Query byWeek = collectionReference
    .where("isConsumed", isEqualTo: false)
    .where("expiryDate", isLessThanOrEqualTo: findLastDateOfTheWeek(date))
    .where("expiryDate", isGreaterThanOrEqualTo: findFirstDateOfTheWeek(date));


    return byWeek.snapshots();
  }

  static Stream<QuerySnapshot> readGroceriesByMonth() {
    DateTime date = DateTime.now();


    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');

    final Query byWeek = collectionReference
        .where("isConsumed", isEqualTo: false)
        .where("expiryDate", isLessThanOrEqualTo: findLastDateOfTheMonth(date))
        .where("expiryDate", isGreaterThanOrEqualTo: findFirstDateOfTheMonth(date));


    return byWeek.snapshots();
  }


  static Stream<QuerySnapshot> readReceipts() {
    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('receipts');

    return collectionReference.snapshots();
  }


  static Future<List> getReceiptData() async {
    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('receipts');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionReference.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  static Future<List> getGroceryData() async {
    CollectionReference collectionReference =
    _mainCollection.doc(userUid).collection('groceries');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionReference.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //print(allData);

    return allData;
  }

  static Future<void> updateGroceries({
    required String docId,
    required String productName,
    required int quantity,
    required String category,
    required DateTime manufacturedDate,
    required DateTime expiryDate,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "productName": productName,
      "quantity": quantity,
      "category": category,
      "manufacturedDate": manufacturedDate,
      "expiryDate": expiryDate,
      "isConsumed": false
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Groceries updated in the database"))
        .catchError((e) => print(e));
  }


  static Future<void> updateReceipt({
    required String docId,
    required String id,
    required String receiptName,
    required int amount,
    required String category,
    required String addedDate,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('receipts').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "receiptName": receiptName,
      "amount": amount,
      "category": category,
      "addedDate": addedDate,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Receipts updated in the database"))
        .catchError((e) => print(e));
  }


  static Future<void> markConsumedGroceries({
    required String docId,
    required int quantity,
    required bool isConsumed
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "quantity" : quantity,
      "isConsumed": isConsumed
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note groceries updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteGrocery({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note groceries deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<void> deleteReceipt({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('receipts').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Receipts deleted from the database'))
        .catchError((e) => print(e));
  }


  static Future<void> deleteUser() async {
    CollectionReference _collectionGroceryRef =
    _mainCollection.doc(userUid).collection('groceries');

    CollectionReference _collectionReceiptRef =
    _mainCollection.doc(userUid).collection('receipts');

    QuerySnapshot queryGrocerySnapshot = await _collectionGroceryRef.get();
    QuerySnapshot queryReceiptSnapshot = await _collectionReceiptRef.get();



    for (int i = 0; i < queryGrocerySnapshot.docs.length; i++) {
      var a = queryGrocerySnapshot.docs[i];
      print(a.id);
      _mainCollection.doc(userUid).collection('groceries').doc(a.id).delete();
    }

    for (int i = 0; i < queryReceiptSnapshot.docs.length; i++) {
      var a = queryReceiptSnapshot.docs[i];
      print(a.id);
      _mainCollection.doc(userUid).collection('receipts').doc(a.id).delete();
    }

    print("all deleted");
  }

}
