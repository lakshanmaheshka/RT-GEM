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
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readGroceries() {
    CollectionReference notesGroceriesCollection =
        _mainCollection.doc(userUid).collection('groceries');

    return notesGroceriesCollection.snapshots();
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
        .whenComplete(() => print("Note groceries updated in the database"))
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

}
