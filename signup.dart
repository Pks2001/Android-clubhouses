import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clubhouses/constant.dart';
import 'package:clubhouses/login.dart';
import 'package:clubhouses/firebase_auth.dart';

import 'constant.dart';
import 'firebase_auth.dart';

class MySignup extends StatefulWidget {
  const MySignup({Key? key}) : super(key: key);

  @override
  _MySignupState createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
      context: context,
    );

  }
  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
        body: Stack(
          children: [
            // Lets add some decorations
            Positioned(
                top: 100,
                right: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: primaryColor,
                  ),
                )
            ),

            Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: primaryColor,
                  ),
                )
            ),
            Positioned(
              bottom: 60,
              left: 50,
              right: 50,
              child: Column(
                children: [
                  Text("Sign Up",style: TextStyle(color: Colors.black,fontSize: 40, fontWeight: FontWeight.bold),),
                  SizedBox(height: 40,),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor.withAlpha(50)
                      ),

                      child: TextField(
                        controller: emailController,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                            icon: Icon(Icons.mail, color: primaryColor),
                            hintText: 'Enter the email',
                            border: InputBorder.none
                        ),
                      )
                  ),
                  SizedBox(height: 20),

                  // Add second text field
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor.withAlpha(50)
                      ),

                      child: TextField(
                        controller: nameController,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person, color: primaryColor),
                            hintText: 'Enter the name',
                            border: InputBorder.none
                        ),
                      )
                  ),

                  SizedBox(height: 20),

                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor.withAlpha(50)
                      ),

                      child: TextField(
                        controller: phoneController,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone, color: primaryColor),
                            hintText: 'Enter the phone',
                            border: InputBorder.none
                        ),
                      )
                  ),

                  SizedBox(height: 20,),

                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor.withAlpha(50)
                      ),

                      child: TextField(
                        controller: passwordController,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: primaryColor),
                            hintText: 'Enter the password',
                            border: InputBorder.none
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  // Add button
                  TextButton(
                      onPressed: signUpUser,

                      child:Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text("SignUp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),

                  SizedBox(height: 20),

                  // Add text button
                  TextButton(
                    onPressed: ()=>Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLogin()),
                    ),
                    child: Text('Already have account? Login',style: TextStyle(color: Colors.black),),
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
