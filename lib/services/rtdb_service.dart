import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_note/models/post_model.dart';

class RTDBService{
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post)async{
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id)async{
    List<Post> items = [];
    Query _query = _database.child("posts").orderByChild("userId").equalTo(id);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.children;

    for(var item in result){
      items.add(Post.fromJson(Map<String,dynamic>.from(item.value as Map)));
    }
    return items;
  }

  static Future<Stream<DatabaseEvent>> update(Post post)async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts");
    String id = "";
    _database.child("posts").onValue.listen((event) {
      id = event.snapshot.children.toList()[0].key.toString();
      print(id);
    });
    if(id.isNotEmpty){
      _database.child("posts").onValue.toList();
    }
    await ref.update({
      "$id/title":post.title,
      "$id/content":post.content
    });
    return _database.onChildChanged;
  }

}

