import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _name = new TextEditingController();
    TextEditingController _key = new TextEditingController();
    return MaterialApp(
      title: "Test Realtime",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test App"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                      child: Text("Created"),
                      onPressed: () {
                        if(_name.text.isEmpty){
                          print("Vui lòng nhập");
                        } else {
                          createData(_name.text);
                          _name.text = "";
                        }
                      }),
                  SizedBox(
                    width: 50,
                  ),
                  RaisedButton(
                      child: Text("Edit"),
                      onPressed: () {
                        if(_name.text.isEmpty){
                          print("Vui lòng nhập");
                        } else {
                          if(_key.text.isEmpty){
                            print("Vui lòng chọn trường muốn sửa");
                          } else {
                            editData(_name.text, _key.text);
                            _name.text = "";
                            _key.text ="";
                          }
                        }
                      }),
                ],
              ),
              Flexible(
                child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.reference().child("Users"),
                  itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation, int index){
                    return InkWell(
                      onTap: (){
                        _name.text = snapshot.value["name"];
                        _key.text = snapshot.key!;
                      },
                      child: new ListTile(
                        trailing: IconButton(icon: Icon(Icons.delete),
                          onPressed: (){
                            FirebaseDatabase.instance.reference().child("Users").child(snapshot.key!).remove();
                          },
                        ),
                        title: new Text(snapshot.value["name"]),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void createData(name){
    final ref = FirebaseDatabase.instance;
    ref.reference().child("Users").push().set({
      'id': Uuid().v4(),
      'name': name
    });
  }
  void editData(name,key){
    final ref = FirebaseDatabase.instance;
    ref.reference().child("Users").child(key).update({
      'name': name
    });
  }
}
