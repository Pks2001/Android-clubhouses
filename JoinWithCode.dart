import 'package:flutter/material.dart';
import 'package:clubhouses/database_helper.dart';
import 'package:clubhouses/RoomScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class JoinWithCode extends StatefulWidget {
  @override
  _JoinWithCodeState createState() => _JoinWithCodeState();
}

class _JoinWithCodeState extends State<JoinWithCode> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text(
          'Join a Room',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _codeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a code';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Room Code',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
                    ),
                  ),
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic>? roomData =
                      await DatabaseHelper.instance.getRoomByCode(_codeController.text);
                      final code = Uuid().v1().substring(0, 6);
                      Map<String, dynamic> row = {
                        DatabaseHelper.columnName: _nameController.text,
                        DatabaseHelper.columnCode: code
                      };
                      if (roomData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => RoomScreen(
                            code: code,
                            roomId: '',
                            roomName: '',
                            users: [],
                            currentUser: _currentUser!,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          _errorMessage = 'Room does not exist';
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: Text(
                    'Join Room',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
