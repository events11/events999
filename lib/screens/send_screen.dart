import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/screens/pagewa_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MessagingPage extends StatefulWidget {
  static const String screenRoute = 'Messagingpage_screen';
 
  final String currentUserId; // معرف المستخدم الحالي
  const MessagingPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  
  final TextEditingController _messageController = TextEditingController();
  String? _selectedFriendId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال رسائل'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // قائمة الأصدقاء
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListTile(
                      title: Text(user['userName']),
                      onTap: () {
                        setState(() {
                          _selectedFriendId = user.id;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          // قسم كتابة الرسالة
          if (_selectedFriendId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty && _selectedFriendId != null) {
                        _sendMessage();
                      }
                    },
                    child: const Text('إرسال'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // إرسال الرسالة
  void _sendMessage() {
    var message = _messageController.text;
    var timestamp = FieldValue.serverTimestamp();

    // إضافة الرسالة إلى مجموعة الرسائل بين المستخدمين
    FirebaseFirestore.instance.collection('messages').add({
      'senderId': widget.currentUserId,
      'receiverId': _selectedFriendId,
      'message': message,
      'timestamp': timestamp,
    });

    // مسح محتوى حقل الرسالة بعد الإرسال
    _messageController.clear();
  }
  
}
