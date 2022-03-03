class Post{
  String? userId;
  String? title;
  String? content;
  String? img_url;
  String? createDate;

  Post(this.userId, this.title, this.content, this.img_url,this.createDate);

  Post.fromJson(Map<String,dynamic> json)
  :userId = json["userId"],
  title = json["title"],
  content = json["content"],
  img_url = json["img_url"],
  createDate = json["createDate"];

  Map<String, dynamic> toJson() => {
    "userId" : userId,
    "title" : title,
    "content" : content,
    "img_url" : img_url,
    "createDate" : createDate,
  };
}