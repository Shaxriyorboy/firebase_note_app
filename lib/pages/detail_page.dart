import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:firebase_note/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  Post? post;
  DetailPage({Key? key,this.post}) : super(key: key);
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
    if(title.isEmpty || content.isEmpty) return;

    if(widget.post != null){
      _apiUpdate(title, content);
    }else{
      _apiAddPost(title, content);
    }
  }

  _apiAddPost(String title,String content)async{
    var id = await HiveDB.loadIdUser();
    RTDBService.addPost(Post(id, title, content)).then((value) => {
      _response(),
    });
  }

  _apiUpdate(String title,String content)async{
    RTDBService.update(Post(widget.post!.userId, title, content)).then((value) => {
      _response(),
    });
  }


  _response()async{
    Navigator.pop(context,true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.post != null){
      setState(() {
        titleController.text = widget.post!.title!;
        contentController.text = widget.post!.content!;
      });
    }
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
