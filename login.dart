import 'package:clubhouses/showSnackbar.dart';
import 'package:clubhouses/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:untitled/firebase_auth.dart';
// import 'package:untitled/signup.dart';
 import 'package:google_sign_in/google_sign_in.dart';
// import 'package:untitled/showSnackbar.dart';
// import 'package:untitled/constant.dart';
import 'package:provider/provider.dart';
// import 'package:untitled/home.dart';

import 'constant.dart';
import 'firebase_auth.dart';
import 'home.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> onSignIn(User? user) async {
    // Do something with the user object, such as navigating to a new page
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
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
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/getslogin.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("Log In",style: TextStyle(color: Colors.black,fontSize: 40, fontWeight: FontWeight.bold),),
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
                      onPressed: loginUser,

                      child:Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text("Log In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),

                  SizedBox(height: 20),

                  TextButton(
                      onPressed: () async {
                        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

                        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
                          // Create a new credential
                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth?.accessToken,
                            idToken: googleAuth?.idToken,
                          );
                          try {
                            final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                            onSignIn(userCredential.user);
                          } on FirebaseAuthException catch (e) {
                            showSnackBar(context, e.message!);
                          }
                        }
                      },

                      child:Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text("Google Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),

                  SizedBox(height: 20),

                  // Add text button
                  TextButton(
                    onPressed: ()=>Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MySignup()),
                    ),
                    child: Text('Dont have account? Sign Up',style: TextStyle(color: Colors.black),),
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
