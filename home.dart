import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:clubhouses/room.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Room Creation',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomCreationPage()),
                );
              },
              child: Text('Create Room'),
            ),
            SizedBox(height: 32.0),
            Text(
              'Room Joining',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomJoiningPage()),
                );
              },
              child: Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomCreationPage extends StatefulWidget {
  @override
  _RoomCreationPageState createState() => _RoomCreationPageState();
}

class _RoomCreationPageState extends State<RoomCreationPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Room'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                labelText: 'Enter room name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String roomName = _roomNameController.text;
                String? roomId = _database.push().key;
                _database.ref.child(roomId!).set({'name': roomName});
                Navigator.pop(context, roomId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(roomId),
                  ),
                );
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomJoiningPage extends StatefulWidget {
  @override
  _RoomJoiningPageState createState() => _RoomJoiningPageState();
}

class _RoomJoiningPageState extends State<RoomJoiningPage> {
  final TextEditingController _roomCodeController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Room'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _roomCodeController,
              decoration: InputDecoration(
                labelText: 'Enter room code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String roomId = _roomCodeController.text;
                DatabaseEvent event = await _database.child(roomId).once();
                if (event.snapshot.value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomPage(roomId: roomId)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid room code'),
                    ),
                  );
                }
              },
              child: Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}


