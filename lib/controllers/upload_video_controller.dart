import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    try {
      print('Compressing video...');
      final compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
      );
      print('Compression complete');
      return compressedVideo?.file;
    } catch (e) {
      print('Error during video compression: $e');
      rethrow;
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    try {
      print('Uploading video...');
      final compressedFile = await _compressVideo(videoPath);
      if (compressedFile == null) throw 'Compressed video is null';
      Reference ref = firebaseStorage.ref().child('videos').child(id);
      UploadTask uploadTask = ref.putFile(compressedFile);
      TaskSnapshot snap = await uploadTask;
      print('Upload complete');
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.back();
      print('Error during video upload: $e');
      rethrow;
    }
  }

  _getThumbnail(String videoPath) async {
    try {
      print('Generating thumbnail...');
      final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
      print('Thumbnail generated');
      return thumbnail;
    } catch (e) {
      print('Error generating thumbnail: $e');
      rethrow;
    }
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  Future<void> uploadVideo(
      String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      await firestore
          .collection('videos')
          .doc('Video $len')
          .set(
            video.toJson(),
          )
          .then((_) {
        print('Document added successfully');
        Get.back();
      }).catchError((e) {
        print('Error adding document: $e');
      });

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
      Get.back();
    }
  }
}
