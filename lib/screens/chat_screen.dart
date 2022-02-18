import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late String textMessages;
  late final textMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                } catch (e) {}
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration.copyWith(
                color: Colors.blueGrey[900],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textMessageController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      onChanged: (value) {
                        textMessages = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textMessageController.clear();
                      _fireStore.collection('messages').add({
                        'text': textMessages,
                        'sender': loggedInUser.email,
                        'times': DateFormat('dd-MM-yyyy KK:mm:ss')
                            .format(DateTime.now()),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final _message = snapshot.requireData.docs;
        List<MessageDesign> messageWidgets = [];
        
        for (var _messageDetails in _message) {
          final messageText = _messageDetails['text'];
          final messageSender = _messageDetails['sender'];

          final _currentUser = loggedInUser.email;
          bool isMe;
          if (_currentUser == messageSender) {
            isMe = true;
          } else {
            isMe = false;
          }
          //TODO: make this messageWidget as a map where key will be date
          //TODO: this date will be using to order the list in DESCENDING ORDER
          final messageWidget = MessageDesign(
              message: messageText,
              sender: messageSender,
              isMe: isMe,
            );

          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageDesign extends StatelessWidget {
  MessageDesign({
    required this.message,
    required this.sender,
    required this.isMe,
  });
  final String message;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: isMe ? 60.0 : 10.0,
          right: isMe ? 10.0 : 60.0,
          top: 5.0,
          bottom: 5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 4.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0))
                : BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 23.0,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          Text(
            sender,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
