import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
   // get the collections of notes
   final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

   // create a new notes
   Future<void> addnote(String note) async {
    try {
      await notes.add({
        'note': note,
        'timestamp': Timestamp.now(),
      });
      print("Note added successfully");
    } catch (e) {
      print("Error adding note: $e");
    }
  }
  //get a stream of data from the cloud_fire
  Stream<QuerySnapshot> getnotes(){
    final snapnotes = notes.orderBy('timestamp',descending: true).snapshots();
    return snapnotes;
  }
  // update the data thrugh the doc id
  Future<void> updatenotes(String docId,String newnote){
    return notes.doc(docId).update({
      'note': newnote,
      'timestamp': Timestamp.now()
    });
  }
  //delete a note
  Future<void> deletenote(String docId){
    return notes.doc(docId).delete();
  }
}