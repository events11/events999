import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hello_world/screens/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*class PagewaScreen extends StatelessWidget {
  static const String screenRoute = 'pagewa_screen';
  const PagewaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}
/*
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة تسجيل الدخول'),
      ),
      body: Center(child: Text('أهلاً بك في صفحة تسجيل الدخول!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        },
        child: Icon(Icons.login),
      ),
    );
  }
}*/

class HomePage extends StatefulWidget {
  
  final _auth = FirebaseAuth.instance;
  late User signedinuser;

 /*void getCurrentuser() {
    try {
      final User = _auth.currentUser;
      if (User != null) {
        signedinuser = User;
        print(signedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }
*/
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User signedinuser;

  void getCurrentuser() {
    try {
      final User = _auth.currentUser;
      if (User != null) {
        signedinuser = User;
        print(signedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  List<Widget> posts = [];
  Locale currentLocale = Locale('en', '');
  final ImagePicker _picker = ImagePicker();

  // لتخزين خيارات الفلتر
  bool isFamilyFriendly = false;
  bool isDaytime = false;
  bool isNighttime = false;
  bool isWinter = false;
  bool isSummer = false;

  void addTextPost() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              currentLocale.languageCode == 'ar' ? 'أضف نصاً' : 'Add Text'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
                hintText: currentLocale.languageCode == 'ar'
                    ? 'أدخل النص هنا'
                    : 'Enter text here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  posts.add(
                    ListTile(
                      title: Text(textController.text),
                      leading: Icon(Icons.text_fields),
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text(currentLocale.languageCode == 'ar' ? 'إضافة' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void addImagePost() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        posts.add(
          ListTile(
            title: Image.file(File(image.path)),
            leading: Icon(Icons.image),
          ),
        );
      });
    }
  }

  void addVideoPost() async {
    // يمكنك إضافة منطق لالتقاط الفيديو هنا باستخدام ImagePicker
  }

  void addLinkPost() {
    TextEditingController linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              currentLocale.languageCode == 'ar' ? 'أضف رابطاً' : 'Add Link'),
          content: TextField(
            controller: linkController,
            decoration: InputDecoration(
                hintText: currentLocale.languageCode == 'ar'
                    ? 'أدخل الرابط هنا'
                    : 'Enter link here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  posts.add(
                    ListTile(
                      title: Text(linkController.text),
                      leading: Icon(Icons.link),
                      onTap: () {
                        // يمكنك إضافة وظيفة لفتح الرابط هنا إذا لزم الأمر
                      },
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text(currentLocale.languageCode == 'ar' ? 'إضافة' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void changeLanguage(Locale locale) {
    setState(() {
      currentLocale = locale;
    });
  }

  void showLanguageMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(currentLocale.languageCode == 'ar'
              ? 'اختر اللغة'
              : 'Select Language'),
          actions: [
            TextButton(
              onPressed: () {
                changeLanguage(Locale('en', ''));
                Navigator.of(context).pop();
              },
              child: Text('English'),
            ),
            TextButton(
              onPressed: () {
                changeLanguage(Locale('ar', ''));
                Navigator.of(context).pop();
              },
              child: Text('العربية'),
            ),
          ],
        );
      },
    );
  }

  void applyFilters() {
    setState(() {
      posts = posts.where((post) {
        // يمكنك إضافة شروط الفلترة هنا
        return true; // استخدم الشرط المناسب لتصفية المنشورات
      }).toList();
    });
    Navigator.of(context).pop(); // إغلاق مربع الحوار بعد تطبيق الفلترة
  }

  void showFilterMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(currentLocale.languageCode == 'ar'
              ? 'اختر الفلتر'
              : 'Select Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: Text(currentLocale.languageCode == 'ar'
                    ? 'مناسب للعائلات'
                    : 'Family Friendly'),
                value: isFamilyFriendly,
                onChanged: (value) {
                  setState(() {
                    isFamilyFriendly = value!;
                  });
                },
                secondary: isFamilyFriendly
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
              ),
              CheckboxListTile(
                title: Text(currentLocale.languageCode == 'ar'
                    ? 'بالنهار'
                    : 'During Day'),
                value: isDaytime,
                onChanged: (value) {
                  setState(() {
                    isDaytime = value!;
                  });
                },
                secondary: isDaytime
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
              ),
              CheckboxListTile(
                title: Text(currentLocale.languageCode == 'ar'
                    ? 'بالليل'
                    : 'During Night'),
                value: isNighttime,
                onChanged: (value) {
                  setState(() {
                    isNighttime = value!;
                  });
                },
                secondary: isNighttime
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
              ),
              CheckboxListTile(
                title: Text(currentLocale.languageCode == 'ar'
                    ? 'بالشتاء'
                    : 'During Winter'),
                value: isWinter,
                onChanged: (value) {
                  setState(() {
                    isWinter = value!;
                  });
                },
                secondary: isWinter
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
              ),
              CheckboxListTile(
                title: Text(currentLocale.languageCode == 'ar'
                    ? 'بالصيف'
                    : 'During Summer'),
                value: isSummer,
                onChanged: (value) {
                  setState(() {
                    isSummer = value!;
                  });
                },
                secondary: isSummer
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child:
                  Text(currentLocale.languageCode == 'ar' ? 'إغلاق' : 'Close'),
            ),
            TextButton(
              onPressed: applyFilters,
              child: Text(currentLocale.languageCode == 'ar' ? 'موافق' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    Navigator.of(context).pop(); // العودة إلى صفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
            currentLocale.languageCode == 'ar' ? 'صفحة المستخدم' : 'User Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showFilterMenu, // أيقونة الفلتر
          ),
          GestureDetector(
            onTap: showLanguageMenu,
            child: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                'A',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Text(currentLocale.languageCode == 'ar'
                      ? 'تسجيل الخروج'
                      : 'Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: posts,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addTextPost,
            tooltip: 'إضافة نص',
            child: Icon(Icons.text_fields),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: addImagePost,
            tooltip: 'إضافة صورة',
            child: Icon(Icons.image),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: addVideoPost,
            tooltip: 'إضافة فيديو',
            child: Icon(Icons.videocam),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: addLinkPost,
            tooltip: 'إضافة رابط',
            child: Icon(Icons.link),
          ),
        ],
      ),
    );
  }
}*/
Widget buildPosts() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['userName']),
            subtitle: Text(data['content']),
            // إضافة المزيد من التفاصيل حسب نوع المنشور (نصي، صورة، موقع)
          );
        }).toList(),
      );
    },
  );
}


Future<void> addMediaPost(String userId, String userName, String content, String mediaUrl) async {
  await FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'mediaUrl': mediaUrl,
    'type': 'media',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

// تحميل صورة/فيديو إلى Firebase Storage
Future<String> uploadMedia(File file) async {
  Reference storageReference = FirebaseStorage.instance.ref().child('posts/${DateTime.now().millisecondsSinceEpoch}');
  UploadTask uploadTask = storageReference.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask;
  return await taskSnapshot.ref.getDownloadURL();
}


class PagewaScreen extends StatelessWidget {
  static const String screenRoute = 'pagewa_screen';
  const PagewaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPostOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // عرض الإشعارات
              _showNotifications(context);
            },
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة الرئيسية')),
    );
  }

  // قائمة تغيير اللغة
  void _showLanguageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                // كود تغيير اللغة إلى العربية
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                // كود تغيير اللغة إلى الإنجليزية
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // خيارات الفلتر
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('المناسبة العائلية'),
              value: false, // حالة الفلتر الأول
              onChanged: (value) {
                // تحديث الفلتر
              },
            ),
            CheckboxListTile(
              title: const Text('الليل'),
              value: false,
              onChanged: (value) {
                // تحديث الفلتر
              },
            ),
            // إضافة باقي خيارات الفلتر بنفس الشكل...
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('رجوع'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // تطبيق الفلاتر المحددة
                    Navigator.pop(context);
                  },
                  child: const Text('موافق'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // خيارات إضافة منشور جديد
  void _showAddPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('إضافة نص'),
              onTap: () {
                // عرض شاشة لإضافة نص فقط
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('إضافة صورة/فيديو'),
              onTap: () {
                // عرض شاشة لإضافة صورة أو فيديو
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('إضافة موقع'),
              onTap: () {
                // عرض شاشة لإضافة موقع
              },
            ),
          ],
        );
      },
    );
  }

  // عرض الإشعارات
  void _showNotifications(BuildContext context) {
    // هنا يمكنك استخدام Firebase Cloud Messaging للحصول على الإشعارات
    // وعرضها عند استلامها.
  }
}
void addTextPost(String userId, String userName, String content) {
  FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'type': 'text',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

void addLocationPost(String userId, String userName, String content, GeoPoint location) {
  FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'location': location,
    'type': 'location',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

void likePost(String postId, String userId) {
  FirebaseFirestore.instance.collection('posts').doc(postId).update({
    'likes': FieldValue.arrayUnion([userId])
  });
}
void commentOnPost(String postId, String userId, String userName, String comment) {
  FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
    'userId': userId,
    'userName': userName,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  });
}