import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

    FirestoreService fire =  FirestoreService();
  TextEditingController mycontroll =  TextEditingController();

  void createnote({String? docId}){
    showDialog(
            context: context,
             builder: (context) => AlertDialog(
               content: TextField(
                controller: mycontroll,
               ),
               actions: [
                ElevatedButton(
                  onPressed: (){
                    if(docId==null){
                      fire.addnote(mycontroll.text);
                    }
                    else{
                      fire.updatenotes(docId, mycontroll.text);
                    }
                    mycontroll.clear();
                    Navigator.of(context).pop();
                  },
                   child: Text('Add')
                )
               ],
             ),
             );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createnote,
        child: Icon(Icons.add,size: 30,),
      ),
      body: StreamBuilder(
        stream: fire.getnotes(),
         builder: (context,snapshot){
           if(snapshot.hasData){
            // get the list of data from firestore
            List noteslist = snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteslist.length,
              itemBuilder: (context,index){
                // get each individual doc form the list
                DocumentSnapshot document = noteslist[index];
                String docId = document.id;
                Map<String,dynamic> data = document.data() as Map<String,dynamic>;

                String notesdata = data['note'];
                
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: Color.fromARGB(255, 242, 227, 192),
                    minVerticalPadding: 20,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(notesdata),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: ()=> createnote(docId: docId), icon: Icon(Icons.settings)),
                        IconButton(onPressed: ()=> fire.deletenote(docId), icon: Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 30,
                        )
                      ],
                    ),
                  ),
                );
              }
              );
           }
           else{
            return Text('No data....');
           }
         }
        ),
    );
  }
}