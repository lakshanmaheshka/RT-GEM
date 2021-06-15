import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('rt_gem');

class Database {
  static String? userUid;

  static Future<void> addGrocery({
    required String productName,
    required String quantity,
    required String category,
    required String manufacturedDate,
    required String expiryDate,
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
    CollectionReference rtGemGroceriesCollection =
        _mainCollection.doc(userUid).collection('groceries');

    return rtGemGroceriesCollection.snapshots();
  }

  static Stream<QuerySnapshot> readReceipts() {
    CollectionReference rtGemGroceriesCollection =
    _mainCollection.doc(userUid).collection('receipts');

    return rtGemGroceriesCollection.snapshots();
  }


  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('collection');

  static Future<List> getData() async {
    CollectionReference rtGemGroceriesCollection =
    _mainCollection.doc(userUid).collection('receipts');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await rtGemGroceriesCollection.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);

    return allData;
  }

  static Future<void> updateGroceries({
    required String docId,
    required String productName,
    required String quantity,
    required String category,
    required String manufacturedDate,
    required String expiryDate,
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
    //required bool isConsumed
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "isConsumed": true
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

}
