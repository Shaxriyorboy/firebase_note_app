import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/pages/detail_page.dart';
import 'package:firebase_note/services/auth_service.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:firebase_note/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  _openDetail()async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return DetailPage();
    }));
    if(result == true){
      _apiGetPosts();
    }
  }

  _apiGetPosts()async{
    var id = await HiveDB.loadIdUser();
    RTDBService.getPosts(id).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts){
    setState(() {
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: items.length,
            itemBuilder: (ctx,index){
          return _itemOfList(index);
        }),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topRight,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        onTap: () {
                          AuthService.signOutUser(context);
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const PopupMenuItem(
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthService.delete(context);
                        },
                        child: ListTile(
                          leading: Icon(Icons.person_add_disabled_outlined),
                          title: Text("Delete Account"),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openDetail();
          },
          child: Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );
  }

  Widget _itemOfList(index){
    return GestureDetector(
      onTap: ()async{
        var result = await Navigator.push(context, MaterialPageRoute(builder: (context){
          return DetailPage(post: items[index],);
        }));
        if(result == true){
          _apiGetPosts();
        }
      },
      child: Card(
        child: ListTile(
          title: Text(items.elementAt(index).title!),
          subtitle: Text(items.elementAt(index).content!),
        ),
      ),
    );
  }
}
