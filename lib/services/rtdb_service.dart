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

    ///items = result.map((json) => Post.fromJson(json.value as Map<String,dynamic>)).toList(); ///this is another solution

    for(var item in result){
      items.add(Post.fromJson(Map<String,dynamic>.from(item.value as Map)));
    }
    return items;

  }

  static Future<Stream<DatabaseEvent>> update(Post post,int index) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts");
    Query _query = _database.child("posts").orderByChild("userId").equalTo(post.userId);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.children.toList();

    await ref.update({
      "${result[index].key}/title":post.title,
      "${result[index].key}/content":post.content
    });
    return _database.onChildChanged;
  }

  static Future<Stream<DatabaseEvent>> delete(int index,String id)async{
    Query _query = _database.child("posts").orderByChild("userId").equalTo(id);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.children.toList();

    DatabaseReference ref = FirebaseDatabase.instance.ref("posts/${result[index].key}");
    await ref.remove();

    return _database.onChildRemoved;
  }

}

