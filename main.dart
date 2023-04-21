import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'package:clubhouses/home.dart';
import 'package:clubhouses/create_room.dart';
import 'package:clubhouses/JoinWithCode.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
          context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'PrivyCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primaryColor: kPrimaryColor,
            textTheme:
            GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
        home: MyLogin(),
      ),
    );
  }
}
