import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>?;
    if (snapshot == null) {
      throw Exception("Video data is null or invalid");
    }

    return Video(
      username: snapshot['username'] ?? '',
      uid: snapshot['uid'] ?? '',
      id: snapshot['id'] ?? '',
      likes: snapshot['likes'] ?? [],
      commentCount: snapshot['commentCount'] ?? 0,
      shareCount: snapshot['shareCount'] ?? 0,
      songName: snapshot['songName'] ?? '',
      caption: snapshot['caption'] ?? '',
      videoUrl: snapshot['videoUrl'] ?? '',
      profilePhoto: snapshot['profilePhoto'] ?? '',
      thumbnail: snapshot['thumbnail'] ?? '',
    );
  }
}
