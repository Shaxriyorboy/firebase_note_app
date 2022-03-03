import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/pages/detail_page.dart';
import 'package:firebase_note/pages/image_page.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  _openDetail() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) {
      return DetailPage();
    }));
    if (result == true) {
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    setState(() {
      isLoading = true;
    });
    var id = HiveDB.loadIdUser();
    await RTDBService.getPosts(id).then((posts) => {
          _respPosts(posts),
        });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  _postDelete(int index) async {
    String id = HiveDB.loadIdUser();
    await RTDBService.delete(index, id).then((posts) => {
          _apiGetPosts(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: !isLoading
            ? RefreshIndicator(
                onRefresh: () {
                  return _apiGetPosts();
                },
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemOfList(index);
                    }),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
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
            print(items.length);
            _openDetail();
            setState(() {});
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _itemOfList(index) {
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) {
          return DetailPage(
            post: items[index],
            index: index,
          );
        }));
        if (result == true) {
          _apiGetPosts();
          setState(() {});
        }
      },
      child: Card(
        child: ListTile(
          title: Text("${items.elementAt(index).title!}  ${items[index].createDate != null?items[index].createDate:"00:00"}"),
          subtitle: Text(items.elementAt(index).content!),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _postDelete(index);
                setState(() {});
              });
            },
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ImagePage(
                      url: items[index].img_url!,
                    );
                  },
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: items[index].img_url != null
                  ? Image(
                      image: NetworkImage(items[index].img_url!),
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    )
                  : Image(
                      image: AssetImage("assets/images/img_1.png"),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
