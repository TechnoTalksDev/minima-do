import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:minima_do/pages/login_page.dart";
import "package:minima_do/services/firestore.dart";


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  final TextEditingController dialogTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void editTask(String docID, String current) {
    dialogTextController.text = current;
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: dialogTextController,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  firestoreService.deleteTask(docID);
                  Navigator.pop(context);
                }, 
                child: Text("Delete")
              ),
              ElevatedButton(
                onPressed: () {
                  firestoreService.updateTask(docID, dialogTextController.text);
                  Navigator.pop(context);
                }, 
                child: Text("Update")
              ),
            ],
          )
        ],
      )
    );
  }

  void addTask  () {
    var currentTask = textController.text;
    textController.text = "";
    firestoreService.addTask(currentTask);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 40,), 
                  Text("${FirebaseAuth.instance.currentUser!.email}", style: TextStyle(fontSize: 10),),
                ],
              ),
              MinimaButton(text: "Sign out", onTap: logout,)
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        IconButton(onPressed: () => _scaffoldKey.currentState!.openDrawer(), icon: Icon(Icons.home_outlined, size: 40, color: theme.primaryColor)),
        //Icon(Icons.home_outlined, size: 40, color: theme.primaryColor),
        const SizedBox(width: 10),
        Text("Tasks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: theme.primaryColor),)
      ],),),
      body: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: StreamBuilder<QuerySnapshot> (
          stream: firestoreService.getTasksStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List taskList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = taskList[index];
                  String docId = document.id;

                  Map<String, dynamic> data = 
                    document.data() as Map<String, dynamic>;
                  String taskText = data["task"];
                  bool taskCompleted = data["completed"];

                  var leadingAction = IconButton(
                      icon: Icon(Icons.circle_outlined, size: 35,),
                      onPressed: () {
                        firestoreService.completeTask(docId);
                      },
                    );  

                  var textStyle = TextStyle(fontSize: 15);

                  if (taskCompleted) {
                    leadingAction = IconButton(
                      icon: Icon(Icons.check, size: 35, color: theme.primaryColor,),
                      onPressed: () {
                        firestoreService.unCompleteTask(docId);
                      },
                    ); 

                    textStyle = TextStyle(fontSize: 15, decoration: TextDecoration.lineThrough);       
                  }

                  return ListTile(
                    leading: leadingAction,
                    title: Text(taskText, style: textStyle),
                    onTap: () {editTask(docId, taskText);},
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {firestoreService.deleteTask(docId);},
                    ),
                  );
                }
              );
            }else {
              return CircularProgressIndicator();
            }
          }
        ),
        bottomNavigationBar: BottomAppBar(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max, // Take up the available width
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the items
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Task"
                ),),
              ),
              SizedBox(width:10),
              ElevatedButton(
                onPressed: () {addTask();},
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
      )

    );
  }
}