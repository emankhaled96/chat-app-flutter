import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUser(),
        builder: (context, futureSnapshot) {
          if(futureSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData) {
            return Container();
          }
          final chatDocs = chatSnapshot.data.docs;
          return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => MessageBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == futureSnapshot.data,
                  chatDocs[index]['username'],
                  chatDocs[index]['imageURL'],
                  key: ValueKey(chatDocs[index].reference.id),)
              );
            }
          );
        });
  }
  Future<String?> getCurrentUser()async{
    User? user = await FirebaseAuth.instance.currentUser;

  String?  userId = user?.uid;
    return userId;
  }
}
