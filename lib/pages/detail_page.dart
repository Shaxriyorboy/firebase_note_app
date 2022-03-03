import 'dart:io';

import 'package:firebase_note/models/post_model.dart';
import 'package:firebase_note/pages/home_page.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:firebase_note/services/rtdb_service.dart';
import 'package:firebase_note/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  int? index;
  Post? post;

  DetailPage({Key? key, this.post, this.index}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if (title.isEmpty || content.isEmpty) return;
    if (widget.post != null) {
      _apiUpdate(title, content, widget.post!.img_url!,
          DateTime.now().toString().substring(10, 16));
    } else {
      _apiUploadImage(
          title, content, DateTime.now().toString().substring(10, 16));
    }
  }

  void _apiUploadImage(String title, String content, String createDate) {
    setState(() {
      isLoading = true;
    });
    _image != null
        ? StoreService.uploadImage(_image!).then(
            (img_url) => {_apiAddPost(title, content, img_url!, createDate)})
        : _apiAddPost(title, content, null, createDate);
  }

  _apiAddPost(
      String title, String content, String? img_url, String createDate) async {
    var id = HiveDB.loadIdUser();
    RTDBService.addPost(Post(id, title, content, img_url, createDate))
        .then((value) => {
              _response(),
            });
  }

  _apiUpdate(
      String title, String content, String imgUrl, String createDate) async {
    setState(() {
      isLoading = true;
    });
    String uid = widget.post!.userId!;
    RTDBService.update(
            Post(uid, title, content, imgUrl, createDate), widget.index!)
        .then((value) => {
              Navigator.pop(context, true),
              setState(() {
                isLoading = false;
              }),
            });
  }

  _response() async {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, true);
  }

  Future _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) {
      setState(() {
        titleController.text = widget.post!.title!;
        contentController.text = widget.post!.content!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        _getImage();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                              )
                            : Image(
                                image: AssetImage("assets/images/img.png"),
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: titleController,
                        decoration:
                            const InputDecoration(hintText: "Enter title"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: contentController,
                        decoration: InputDecoration(hintText: "Enter content"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          _addPost();
                        },
                        color: Colors.blue,
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const LinearProgressIndicator(
                      minHeight: 7,
                      color: Colors.red,
                      backgroundColor: Colors.black,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
