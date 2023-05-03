import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {


  List<bool> isSelected = [false,false,false];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(30),
                child: Text('Welcome Back', style: TextStyle(fontSize: 40),)
            ),
            StreamBuilder<DateTime>(
              stream: Stream.periodic(Duration(seconds: 1), (i) => DateTime.now()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Text(
                        'Current Time:',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Text(
                        '${snapshot.data}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
