import 'dart:async';


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:clubhouses/callpage.dart';

class RoomPage extends StatefulWidget {
  final String roomId;

  const RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  StreamSubscription<DatabaseEvent>? _messagesSubscription;
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesSubscription = _database.child(widget.roomId).child('messages').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? messages = event.snapshot.value as Map?;
        List<String> newMessages = [];
        messages!.forEach((key, value) {
          newMessages.add(value['text']);
        });
        setState(() {
          _messages = newMessages;
        });
      }
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    String messageText = _messageController.text;
                    if (messageText.isNotEmpty) {
                      String? messageId = _database.child(widget.roomId).child('messages').push().key;
                      _database.child(widget.roomId).child('messages').child(messageId!).set({
                        'text': messageText,
                        'timestamp': ServerValue.timestamp,
                      });
                      _messageController.clear();
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the call page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CallPage(channelId: widget.roomId)),
          );
        },
        child: Icon(Icons.call),
      ),
    );
  }
}
