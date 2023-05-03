import 'package:car_days_employee/Login.dart';
import 'package:car_days_employee/employeeFeature.dart';
import 'package:car_days_employee/homePage.dart';
import 'package:car_days_employee/profile.dart';
import 'package:car_days_employee/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_days_employee/user.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Widget home;
    if(firebaseUser != null){
      home = MyHomePage(title: 'CarDaysEmployee');
    }else{
      home = EmployeeLogin();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarDaysEmployee',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: home,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final int landingIndex = 0;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  int _currIndex = 0;

  List<Widget> _children() => [
    homePage(),
    EmployeePage(),
    profilePage(),
  ];

  void onTappedBar(int index){
    setState((){
      _currIndex = index;
    });

  }


  @override
  Widget build(BuildContext context) {
    final _controller = PageController(initialPage: 0);
    final List<Widget> children = _children();

    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Employee' , style: TextStyle(fontFamily: 'Louis', fontSize: 25, color: Colors.black),),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            shadowColor: Colors.transparent,
          ),
          body: PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                onTappedBar(index);
              });
            },
            children: _children(),
          ),
          //children[_currIndex],
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixedCircle,
            items: [
              TabItem(icon: Icons.home_filled, title: 'Landing'),
              TabItem(icon: Icons.bolt_sharp, title: 'Feature'),
              TabItem(icon: Icons.menu, title: 'Profile'),
            ],
            color: Colors.black87,
            backgroundColor: Colors.blueAccent,
            activeColor: Colors.white,
            initialActiveIndex: 0,
            onTap: (int index) {
              onTappedBar(index);
              _controller.animateToPage(
                  index,
                  duration: Duration(milliseconds: 450),
                  curve: Curves.easeInOut
              );
            },
          )
      ),

    );
  }
}
