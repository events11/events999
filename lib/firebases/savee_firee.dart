import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // حفظ بيانات المستخدم
  Future<void> saveUserData(String userId, String name, String bio) async {
    try {
      await _db.collection('users').doc(userId).set({
        'name': name,
        'bio': bio,
        'profileImage': 'url_to_image',  // يمكنك تخزين رابط الصورة إذا كنت تستخدم Firebase Storage
      });
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // استرجاع بيانات المستخدم
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _db.collection('users').doc(userId).get();
  }
}
