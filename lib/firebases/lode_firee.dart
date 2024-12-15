import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // رفع صورة
  Future<String> uploadProfileImage(File image, String userId) async {
    try {
      // تحديد اسم الملف
      String fileName = 'profile_$userId.jpg';
      Reference ref = _storage.ref().child('profile_images').child(fileName);

      // رفع الصورة
      await ref.putFile(image);

      // الحصول على رابط الصورة بعد الرفع
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }
}
