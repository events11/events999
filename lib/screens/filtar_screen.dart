import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:hello_world/generated/l10n.dart';
import 'package:hello_world/screens/ProfilePage_screen.dart';
import 'package:hello_world/screens/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'language_screen.dart';
import 'post_screen.dart';
import 'package:intl/intl.dart';

class FiltarScreen extends StatefulWidget {
  static const String screenRoute = 'pagewa_screen';
  const FiltarScreen({super.key});

  @override
  State<FiltarScreen> createState() => _PagewaScreenState();
}

class _PagewaScreenState extends State<FiltarScreen> {
  int _selectedIndex = 0;
  final TextEditingController _postController = TextEditingController();
  List<Map<String, dynamic>> _filteredPosts = [];
  List<Map<String, dynamic>> _allPosts = [];
  String? _currentFilter;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        _showNotificationsDialog();
      }
    });
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications, color: Colors.blue),
              SizedBox(width: 8),
              Text(S.of(context).notifications)
            ],
          ),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final notifications = snapshot.data!.docs;
              if (notifications.isEmpty) {
                return Text(S.of(context).Noewnotifications);
              }

              return SizedBox(
                height: 20,
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: notifications.map((doc) {
                    final notification = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(notification['message']),
                      subtitle: Text('في ${notification['timestamp'].toDate()}'),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
File? _mediaFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).homePage),
        backgroundColor: const Color.fromARGB(255, 148, 21, 133),
        actions: [
          IconButton(
            iconSize: 35,
            color: Colors.black,
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            iconSize: 35,
            color: Colors.black,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomeScreen.screenRoute,
                (Route<dynamic> route) => false,
              );
            },
          ),
          
        ],
      ),

      /*body: Column(
        children: [
          Expanded(child: buildPosts()),
        ],*/
         body: IndexedStack(
        index: _selectedIndex,
        children: [
          LanguageScreen(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: S.of(context).Writeyourpost,
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, CreatePostPage.screenRoute);
                          },
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/event999-83c8c.firebasestorage.app/o/OIP.jpg?alt=media&token=f911e404-b4ba-45f0-a077-b3bb7a721b87'), // استبدل هذا بالرابط الفعلي للصورة
                          radius: 22, // لتحديد حجم الصورة
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: buildPosts()),
            ],
          ),
          Container(), // فارغ لأنه يتم عرض الإشعارات في نافذة منبثقة
          ProfilePage(), //الفحة الاخيرة
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 148, 21, 133),
        selectedItemColor: const Color.fromARGB(255, 58, 103, 65),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            label: S.of(context).language,
            icon: const Icon(Icons.language),
          ),
          BottomNavigationBarItem(
            label: S.of(context).home,
            icon: const Icon(Icons.house),
          ),
          BottomNavigationBarItem(
            label: S.of(context).notifications,
            icon: const Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: S.of(context).person,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  // فلتر المنشورات بناءً على التصنيف المحدد
  void _filterByCategory(String category, BuildContext context) async {
    Navigator.pop(context); // إغلاق ورقة السحب

    try {
      // إذا تم اختيار "تصنيف 5"، نعرض جميع المنشورات
      final querySnapshot = (category == 'تصنيف 5')
          ? await FirebaseFirestore.instance
              .collection('users')
              .orderBy('timestamp', descending: true)
              .get()
          : await FirebaseFirestore.instance
              .collection('users')
              .where('category', isEqualTo: category)
              .orderBy('timestamp', descending: true)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _filteredPosts = querySnapshot.docs.map((doc) => doc.data()).toList();
          _currentFilter = category; // تتبع التصنيف الحالي
        });
      } else {
        setState(() {
          _filteredPosts = []; // عرض رسالة لا توجد منشورات
        });
      }
    } catch (e) {
      print("Error filtering posts: $e");
      setState(() {
        _filteredPosts = []; // عرض رسالة خطأ
      });
    }
  }

  // عرض ورقة الفلتر مع 4 تصنيفات بالإضافة إلى تصنيف 5
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('تصنيف 1'),
              onTap: () => _filterByCategory('تصنيف 1', context),
            ),
            ListTile(
              title: const Text('تصنيف 2'),
              onTap: () => _filterByCategory('تصنيف 2', context),
            ),
            ListTile(
              title: const Text('تصنيف 3'),
              onTap: () => _filterByCategory('تصنيف 3', context),
            ),
            ListTile(
              title: const Text('تصنيف 4'),
              onTap: () => _filterByCategory('تصنيف 4', context),
            ),
            ListTile(
              title: const Text('عرض جميع المنشورات'),
              onTap: () => _filterByCategory('تصنيف 5', context), // التصنيف 5 لعرض جميع المنشورات
            ),
          ],
        );
      },
    );
  }

  // بناء واجهة المنشورات
  Widget buildPosts() {
    final posts = _filteredPosts.isNotEmpty ? _filteredPosts : _allPosts;

    if (posts.isEmpty) {
      return const Center(child: Text('لا توجد منشورات حالياً.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        }
        final posts = snapshot.data!.docs;
        print(" object$posts");
        if (posts.isEmpty) {
          return const Center(child: Text('لا توجد منشورات حالياً.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // محاذاة النص والصورة من البداية
                children: [
                  // النص (content)
                  Text(
                    data['content'] ?? 'محتوى غير متوفر',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5), // مسافة صغيرة بين TEXT والرابط
                  // عرض التاريخ والوقت
                  Text(
                    formatDate(data['timestamp']), // استدعاء دالة تنسيق التاريخ
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (data['location'] != null && data['location'].isNotEmpty) ...[
                    GestureDetector(
                      onTap: () {
                        // منطق فتح الموقع عند الضغط على الرابط (مثلاً باستخدام URL launcher)
                      },
                      child: Text(
                        data['location'],
                        style: TextStyle(
                          color: Colors.blue,
                          decoration:
                              TextDecoration.underline, // لتحديد النص كرابط
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ] else ...[
                    // عرض نص بديل في حال لم يكن الموقع متوفرًا
                    Text(
                      'موقع غير متوفر',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  // الصورة
                  SizedBox(
                    width: double.infinity, // عرض كامل للصورة
                    height: 200, // تحديد ارتفاع الصورة
                    child: Image.network(
                      "${data['ImageUrl']}",
                      fit: BoxFit.contain, // لتغطية المساحة بشكل مناسب
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image,
                            color: const Color.fromARGB(
                                255, 58, 53, 53)); // عند وجود خطأ في تحميل الصورة
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // دالة تنسيق التاريخ
  String formatDate(dynamic timestamp) {
    try {
      // تأكد من أن timestamp هو من نوع Timestamp
      if (timestamp is Timestamp) {
        final DateTime dateTime =
            timestamp.toDate(); // تحويل الـ Timestamp إلى DateTime
        final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
        return formatter.format(dateTime); // إعادة تنسيق التاريخ
      } else {
        return 'تاريخ غير صالح';
      }
    } catch (e) {
      return 'تاريخ غير صالح';
    }
  }

  // تحميل صورة/فيديو إلى Firebase Storage
  Future<String> uploadMedia(File file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
