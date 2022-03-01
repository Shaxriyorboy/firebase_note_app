import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:firebase_note/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost()async{
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    var id = await HiveDB.loadIdUser();
    RTDBService.addPost(Post(id, title, content)).then((value) => {
      print(value.toString()),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Enter title"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: contentController,
                  decoration: InputDecoration(hintText: "Enter content"),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: (){
                    _addPost();
                  },
                  color: Colors.blue,
                  child: Text("Save",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
