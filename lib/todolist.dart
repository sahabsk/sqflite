import 'package:flutter/material.dart';
import 'package:sqf_lite/database_helper.dart';

import 'models.dart';
import 'dart:async';

class ToDoListApp extends StatefulWidget {
  const ToDoListApp({Key? key}) : super(key: key);

  @override
  State<ToDoListApp> createState() => _ToDoListAppState();
}

class _ToDoListAppState extends State<ToDoListApp> {
  DatabaseHelper? dbHelper;
  late Future<List<Models>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDoList App"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<Models>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              dbHelper!.update(
                                Models(
                                  id : snapshot.data![index].id!,
                                    title: "Second Notes",
                                    age: 10,
                                    description: "This is second notes")
                              );
                              setState(() {
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              key: ValueKey<int>(snapshot.data![index].id!),
                              background: Container(
                                child: Icon(Icons.delete_forever),
                                color: Colors.red,
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      snapshot.data![index].title.toString()),
                                  subtitle: Text(snapshot.data![index].description
                                      .toString()),
                                  trailing:
                                      Text(snapshot.data![index].age.toString()),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(
            Models(
                title: 'First Notes',
                age: 27,
                description: 'This is the first notes.'),
          )
              .then(
            (value) {
              setState(() {
                notesList = dbHelper!.getNotesList();
              });
            },
          ).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
