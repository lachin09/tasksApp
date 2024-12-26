import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");
//Create notes
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  // read notes
  Stream<QuerySnapshot> getNoteStream() {
    return FirebaseFirestore.instance.collection('notes').snapshots();
  }

  // update notes

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // delete note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
