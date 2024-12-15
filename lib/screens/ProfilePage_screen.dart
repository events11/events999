import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const String screenRoute = 'ProfilePage_screen';
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase Storage')),
        body: Center(child: Text('Firebase Storage Enabled')),
      ),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _name = '';
  String _bio = '';
  String _profileImageUrl =
      'https://www.w3schools.com/w3images/avatar2.png'; // صورة افتراضية
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // تحميل بيانات المستخدم من Firebase
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // استرجاع بيانات المستخدم من Firestore
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _name = userData['name'] ?? 'اسم غير متوفر';
            _bio = userData['bio'] ?? 'لا يوجد سيرة ذاتية';
            _profileImageUrl = userData['imags'] ?? _profileImageUrl;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error loading user data: $e");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // رفع صورة جديدة للمستخدم
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      String imageUrl = await _uploadProfileImage(image);
      setState(() {
        _profileImageUrl = imageUrl;
      });
      await _updateUserProfileImage(imageUrl);
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<String> _uploadProfileImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('tareq/${_auth.currentUser!.uid}/profile_image.jpg');
      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return _profileImageUrl; // الصورة الافتراضية عند حدوث خطأ
    }
  }

  // تحديث صورة الملف الشخصي في Firestore
  Future<void> _updateUserProfileImage(String imageUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'imags': imageUrl,
        });
      } catch (e) {
        print("Error updating profile image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
     appBar: AppBar(
        title: const Text('الصفحة الشخصية'),
       backgroundColor: Colors.blue,
      ),*/
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 10),
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildPostSection(),
                ],
              ),
            ),
    );
  }

  // بناء الرأس (صورة الملف الشخصي وغلاف)
  Widget _buildProfileHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          color: const Color.fromARGB(255, 188, 153, 24),
        ),
        Positioned(
          top: 120,
          left: 20,
          child: GestureDetector(
            onTap: _pickAndUploadImage, // اختيار صورة جديدة
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_profileImageUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _bio,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton('إضافة صديق'),
        const SizedBox(width: 10),
        _buildActionButton('إرسال رسالة'),
      ],
    );
  }

  Widget _buildActionButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // الإجراء عند النقر على الزر
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 216, 196, 9),
      ),
      child: Text(label),
    );
  }

  Widget _buildPostSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المنشورات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildPost('مرحباً!'),
        ],
      ),
    );
  }

  Widget _buildPost(String content) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(content),
    );
  }

  // باقي الوظائف كالمذكورة في الكود السابق
}
