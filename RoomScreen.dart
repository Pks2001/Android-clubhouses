import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_database/firebase_database.dart';

class RoomScreen extends StatefulWidget {
  final String code;
  final String roomId;
  final String roomName;
  final List<String> users;
  final User currentUser;

  RoomScreen({
    required this.code,
    required this.roomId,
    required this.roomName,
    required this.users,
    required this.currentUser,
  });

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late DatabaseReference _messagesRef;
  late TextEditingController _textEditingController;
  late List<Message> _messagesList;
  late User currentUser;

  @override
  void initState() {
    super.initState();

    // Initialize database reference
    _messagesRef = FirebaseDatabase.instance.reference().child('rooms/${widget.roomId}/messages');

    // Initialize text editing controller
    _textEditingController = TextEditingController();

    // Initialize messages list
    _messagesList = [];
    _messagesRef.onChildAdded.listen((event) {
      setState(() {
        _messagesList.add(Message.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Release resources
    _textEditingController.dispose();
    _messagesRef.onChildAdded.drain();
  }

  void _sendMessage(String message) {
    // Save message to database
    _messagesRef.push().set(Message(
      sender: widget.currentUser.displayName ?? widget.currentUser.uid,
      content: message,
    ).toMap());

    // Clear text field
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Close audio session
              FlutterSoundPlayer().stopPlayer();

              // Release resources
              FlutterSoundPlayer().stopPlayer();

              // Navigate back to home screen
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messagesList.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messagesList[index];

                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.content),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    _sendMessage(_textEditingController.text);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String content;

  Message({
    required this.sender,
    required this.content,
  });

  // Construct a Message object from a DataSnapshot object
  Message.fromSnapshot(DataSnapshot snapshot)
      : sender = (snapshot.value as Map<String, dynamic>)['sender'],
        content = (snapshot.value as Map<String, dynamic>)['content'];




  // Convert a Message object to a Map object for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'content': content,
    };
  }
}
