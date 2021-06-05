import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }


  static Future<void> addGrocery({
    required String productName,
    required String category,
    required String manufacturedDate,
    required String expiryDate,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "productName": productName,
      "category": category,
      "manufacturedDate": manufacturedDate,
      "expiryDate": expiryDate,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateGroceries({
    required String productName,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('groceries').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "productName": productName,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note groceries updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readGroceries() {
    CollectionReference notesGroceriesCollection =
        _mainCollection.doc(userUid).collection('groceries');

    return notesGroceriesCollection.snapshots();
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
    _mainCollection.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
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
