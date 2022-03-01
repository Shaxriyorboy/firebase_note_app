import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/pages/detail_page.dart';
import 'package:firebase_note/services/auth_service.dart';
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
    items.add(Post("1", "title", "content"));
    items.add(Post("2", "title1", "content"));
    items.add(Post("3", "title2", "content"));
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
            Navigator.of(context).pushNamed(DetailPage.id);
          },
          child: Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );
  }

  Widget _itemOfList(index){
    return Card(
      child: ListTile(
        title: Text(items.elementAt(index).title!),
        subtitle: Text(items.elementAt(index).content!),
      ),
    );
  }
}
