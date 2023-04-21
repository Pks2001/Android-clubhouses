import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CallPage extends StatefulWidget {
  final String channelId;

  CallPage({Key? key, required this.channelId}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late DatabaseReference _reference;
  bool _joined = false;
  int _remoteUid = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _reference.remove();
    super.dispose();
  }

  Future<void> _initialize() async {
    // Get Firebase Realtime Database reference
    _reference = FirebaseDatabase.instance.reference().child(widget.channelId);

    // Set up event listeners
    _reference.onChildAdded.listen((event) {
      if (event.snapshot.key == 'joined') {
        setState(() {
          _joined = true;
        });
      } else if (event.snapshot.key == 'remoteUid') {
        setState(() {
          _remoteUid = event.snapshot.value as int;
        });
      }
    });

    _reference.onChildChanged.listen((event) {
      if (event.snapshot.key == 'remoteUid') {
        setState(() {
          _remoteUid = event.snapshot.value as int;
        });
      }
    });

    // Join channel
    await _reference.child('joined').set(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Channel ID: ${widget.channelId}'),
          SizedBox(height: 16.0),
          _remoteUid == 0 ? Text('Waiting for remote user...') : Text('Remote user UID: $_remoteUid'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _reference.child('joined').set(false);
              Navigator.pop(context);
            },
            child: Text('Hang up'),
          ),
        ],
      ),
    );
  }
}