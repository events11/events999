import 'dart:io';
import 'package:hello_world/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'language_screen.dart';
import 'pagewa_screen.dart';
import 'package:intl/intl.dart';

class CreatePostPage extends StatefulWidget {
  static const String screenRoute = 'post_screen'; // تعريف واحد للثابت

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _filterByCategory = TextEditingController();
  final TextEditingController _currentFilter = TextEditingController();
  File? _pickedFile; // لتخزين الصورة أو الفيديو
  DateTime? _selectedDateTime; // لتخزين التاريخ والوقت المختار
  // دالة لاختيار التاريخ والوقت
  Future<void> _selectDateTime() async {
    // اختيار التاريخ
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('en', 'US'), // ضبط اللغة إلى الإنجليزية
    );

    if (selectedDate != null) {
      // اختيار الوقت
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        builder: (BuildContext context, Widget? child) {
          return Localizations.override(
            context: context,
            locale: const Locale('en', 'US'), // ضبط اللغة إلى الإنجليزية
            child: child,
          );
        },
      );

      if (selectedTime != null) {
        // دمج التاريخ والوقت
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: Text(S.of(context).Createapost),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل النص
              TextField(
                controller: _postController,
                maxLines: null, // السماح بخطوط متعددة
                decoration: InputDecoration(
                  hintText: (S.of(context).Text),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              // رابط الموقع
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: (S.of(context).Addalocation), //
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16.0),
              // زر تحديد الوقت
              GestureDetector(
                onTap: _selectDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 14, 18, 22), width: 2),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    _selectedDateTime == null
                        ? (S.of(context).Addalocation)
                        : 'الوقت المحدد: ${_selectedDateTime!.toLocal().toString().split(' ')[0]} ${_selectedDateTime!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 1, 3, 4),
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              //
              TextField(
                controller: _currentFilter,
                decoration: InputDecoration(
                  hintText: (S.of(context).Addalocation), //
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
              ),

              // إضافة صورة/فيديو
              /*if (_pickedFile != null)
                Column(
                  children: [
                    const SizedBox(height: 50),
                    _pickedFile!.path.endsWith('.mp4') // تحقق إذا كان فيديو
                        ? Icon(Icons.videocam, size: 200, color: const Color.fromARGB(255, 230, 225, 225))
                        : Image.file(
                            File(_pickedFile!.path),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ],
                ),*/
              if (_pickedFile != null)
                Column(
                  children: [
                    _pickedFile!.path.endsWith('.mp4')
                        ? Text('فيديو مرفق')
                        : Image.file(
                            File(_pickedFile!.path),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ],
                ),

              const SizedBox(height: 10.0),
              ElevatedButton.icon(
                  onPressed: () => _pickMedia(context),
                  icon: Icon(Icons.photo),
                  label: Text(S.of(context).Addphotovideo)),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                    onPressed: _createPost,
                    child: Text(S.of(context).Sharethepost)),
              ),

              /*  ElevatedButton.icon(
                
                onPressed: () => _pickMedia(context),
                icon: Icon(
                  Icons.photo,
                  color: const Color.fromARGB(255, 18, 189, 3),),
                  
                label: Text(
    'إضافة صورة/فيديو',
    style: TextStyle(
      color: const Color.fromARGB(255, 32, 30, 30), // لون الخط
      fontSize: 16, // يمكنك تعديل الحجم إذا أردت
      fontWeight: FontWeight.bold, // تغيير وزن الخط (اختياري)
    ),
  ),
              ),
              const SizedBox(height: 16.0),

              // زر النشر
              Center(
                
                child: ElevatedButton(
                  
                  onPressed: _createPost,
                  child: Text('post',
                  style: TextStyle(
      color: const Color.fromARGB(255, 17, 47, 195), // لون الخط
      fontSize: 16, // يمكنك تعديل الحجم إذا أردت
      fontWeight: FontWeight.bold, // تغيير وزن الخط (اختياري)
    ),),

                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

// دالة لتحميل الملف إلى Firebase Storage
  Future<String?> uploadFileToStorage(File file) async {
    try {
      // Create a reference to Firebase Storage
      // Generate a unique file name based on the current timestamp

      // Create a reference for the file within the 'images' directory
 
      // Convert XFile to File and upload it
      final storageReference = FirebaseStorage.instance.ref()
      .child('uploads/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageReference.putFile(File(file.path));
      // Wait for the file upload to complete
      final snapshot = await uploadTask;
      // Retrieve the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('خطأ في تحميل الملف إلى Firebase Storage: $e');
      return "https://firebasestorage.googleapis.com/v0/b/event999-83c8c.firebasestorage.app/o/7777.jpg?alt=media&token=1bd71454-a281-4561-a13a-1fe047ff8838";
    }
  }

  // دالة اختيار الوسائط (صورة أو فيديو)
  Future<void> _pickMedia(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(S.of(context).Chooseapictur),
              onTap: () async {
                Navigator.pop(context,
                    await picker.pickImage(source: ImageSource.gallery));
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text(S.of(context).Videoselection),
              onTap: () async {
                Navigator.pop(context,
                    await picker.pickVideo(source: ImageSource.gallery));
              },
            ),
          ],
        );
      },
    );
    setState(() {
      _pickedFile = File(pickedFile!.path);
    });
  }

  void addPost(
    String userId,
    String userName,
    String content, {
    String? ImageUrl,
    String? location,
    DateTime? timestamp,
    //String? category,
    required int category,
  }) {
    // إنشاء خريطة تحتوي على القيم الأساسية فقط
    final postData = {
      //'userId': userId,
      //'userName': userName,
      'content': content,
      'ImageUrl': ImageUrl ?? '', // إذا لم يتم اختيار صورة
      'location': location ?? '', // إذا لم يتم إدخال موقع
      'category': category,
      'times': FieldValue.serverTimestamp(),
      'timestamp': timestamp ?? '',
      // وقت النشر
    };

    // إضافة الحقل timestamp إذا كان محددًا
    if (timestamp != null) {
      postData['timestamp'] = timestamp;
    }

    // إرسال البيانات إلى قاعدة البيانات
    FirebaseFirestore.instance.collection('users').add(postData).then((value) {
      print('تمت إضافة المنشور بنجاح.');
    }).catchError((error) {
      print('فشل في إضافة المنشور: $error');
    });
  }

// تعديل دالة _createPost
  void _createPost() async {
    final postText = _postController.text.trim();
    final location = _locationController.text.trim();
    final category = int.tryParse(_currentFilter.text.trim()) ?? 0; // ت

    // التحقق من الحقول الفارغة
    if (postText.isEmpty && _pickedFile == null && location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال نص أو إضافة ملف أو موقع.')),
      );
      return;
    }

    // إعداد الوقت إذا تم اختياره
    DateTime? timestamp = _selectedDateTime;
    // تحميل الملف إلى Firebase Storage إذا كان موجودًا
    String? images;
    if (_pickedFile != null) {
      images = await uploadFileToStorage(_pickedFile!);
      if (images == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحميل الملف.')),
        );
        return;
      }
    }
    // استدعاء الدالة addPost
    addPost(
      FirebaseAuth.instance.currentUser!.uid, // ID المستخدم
      FirebaseAuth.instance.currentUser!.displayName ?? "مجهول", // اسم المستخدم
      postText, // النص المدخل
      ImageUrl:images, // رابط الملف المختار (اختياري)
      location: location, // الموقع المدخل (اختياري)
      category: category, // إضافة التصنيف
      timestamp: timestamp, // التاريخ المحدد (اختياري)
    );

    // طباعة البيانات في وحدة التحكم (لأغراض تصحيح الأخطاء)
    print('نص المنشور: $postText');
    print('رابط الموقع: $location');
    if (_pickedFile != null) {
      print('تم اختيار ملف: ${_pickedFile!.path}');
    }
    if (timestamp != null) {
      print('التاريخ المختار: $timestamp');
    }

    // إعادة تعيين الحقول بعد الإرسال
    _postController.clear();
    _locationController.clear();
    _filterByCategory.clear();
    setState(() {
      _pickedFile = null;
      _selectedDateTime = null; // إعادة تعيين الوقت
      _currentFilter.clear(); // إعادة تعيين التصنيف
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نشر المنشور بنجاح!')),
    );
  }
}
