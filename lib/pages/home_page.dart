import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/services/firestroe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreServices firestoreServices = FirestoreServices();
  final TextEditingController textcontroller = TextEditingController();

  void openNoteBox(String? docID, [String? initialText]) {
    if (initialText != null) {
      textcontroller.text = initialText;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textcontroller,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreServices.addNote(textcontroller.text);
              } else {
                firestoreServices.updateNote(docID, textcontroller.text);
              }
              textcontroller.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(null),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreServices.getNoteStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = noteList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return (Row(
                  children: [
                    Expanded(
                      child: Text(
                        noteText,
                      ),
                    ),
                    IconButton(
                      onPressed: () => openNoteBox(docID, noteText),
                      icon: const Icon(
                        Icons.settings,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => firestoreServices.deleteNote(docID),
                      icon: const Icon(
                        Icons.delete,
                        size: 24,
                      ),
                    ),
                  ],
                ));
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('no note yet !!!'));
          }
        },
      ),
    );
  }
}
