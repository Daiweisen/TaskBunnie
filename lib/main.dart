import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screen.dart/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
             apiKey: "AIzaSyDMZqgzihSv8D4O8LddxRxNKirAfLUpkpo",
  authDomain: "taskbunny-58049.firebaseapp.com",
  projectId: "taskbunny-58049",
  storageBucket: "taskbunny-58049.appspot.com",
  messagingSenderId: "522989060345",
  appId: "1:522989060345:web:c6e8ba1d0680300a172228",
  measurementId: "G-NLD1S43RPG"
          )
        : null,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(430, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
  
      
    
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskBunny',
          theme: ThemeData(
            fontFamily: "Poppins",
            scaffoldBackgroundColor: const Color(0xFF0F1523),
          ),
          home:  HomeScreen(),
        );
      }
  
  }