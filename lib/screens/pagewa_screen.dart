import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PagewaScreen extends StatelessWidget {
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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
}
