import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_days_employee/checkuser.dart';
import 'package:car_days_employee/serviceCentre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class EmployeeLogin extends StatefulWidget {
  const EmployeeLogin({Key? key}) : super(key: key);

  @override
  State<EmployeeLogin> createState() => _EmployeeLoginState();
}

class _EmployeeLoginState extends State<EmployeeLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isAuthorized = false;
  GlobalKey<FormState> addVehicleFormKey = GlobalKey<FormState>();
  void _showLoginToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Login Successful!'),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: 200,
        elevation: 10,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyanAccent, Colors.blueAccent]
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 70, 20, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Employee panel",
                                style: TextStyle(fontSize: 35, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                  child: AutoSizeText(
                                                    "Login",
                                                    style: TextStyle(fontFamily: 'Daviton', fontSize: 30, color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: _emailController,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: "Email.",
                                                      labelStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Louis',
                                                        color: Color(0xFF95A1AC),
                                                      ),
                                                      hintText: "Enter your email here.",
                                                      hintStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Louis',
                                                        color: Color(0xFF95A1AC),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white70,
                                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'Louis',
                                                      fontSize: 20,
                                                      color: Color(0xFF2B343A),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 20),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: _passwordController,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: "Password:",
                                                      labelStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Louis',
                                                        color: Color(0xFF95A1AC),
                                                      ),
                                                      hintText: "Enter your password here.",
                                                      hintStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Louis',
                                                        color: Color(0xFF95A1AC),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white70,
                                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'Louis',
                                                      fontSize: 20,
                                                      color: Color(0xFF2B343A),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 2,
                                            thickness: 2,
                                            indent: 20,
                                            endIndent: 20,
                                            color: Color(0xFFDBE2E7),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 16),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    try{
                                                      final login = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                        email: _emailController.text.trim(),
                                                        password: _passwordController.text.trim(),
                                                      ).then((value) async {
                                                        if(value!= null && value.user != null){
                                                          print('Successful Login!');
                                                          _showLoginToast(context);
                                                          print(value.user!.uid);
                                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => checkuser()), (route) => false);
                                                        }
                                                        else{
                                                          print('im here');
                                                        }
                                                      }).onError((error, stackTrace) {
                                                        print('im here error');
                                                        print(error);
                                                      });
                                                    }on FirebaseAuthException catch(e){
                                                      if (e.code == 'user-not-found') {
                                                        print('No user found for that email.');
                                                      } else if (e.code == 'wrong-password') {
                                                        print('Wrong password provided for that user.');
                                                      }
                                                    }

                                                    //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) =>EmployeePage()), (route) => false);
                                                  },
                                                  child: Text(
                                                    "Login",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Louis',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    fixedSize: MaterialStateProperty.all<Size>(Size(110, 50)),
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                          side: BorderSide(color: Colors.transparent)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },

        ),
      ),
    );

  }
  Future<List<Employee>> getEmployees() async {

    List<serviceCentre> scList = [];
    List<Employee> empList = [];
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length > 0){
      scList = snapshot.docs.map((doc) => serviceCentre(doc['Name'], doc['State'], doc['City'], doc['Street'], doc['Postcode'], doc['Uid'], doc['ContactNumber'])).toList();
    }


    for(serviceCentre sc in scList){
      QuerySnapshot snap = await ref.doc(sc.Uid).collection('Employees').get();
      List<Employee> temp = [];
      if(snap.docs.length > 0){
        temp = snap.docs.map((doc) => Employee(doc['BayInCharge'], doc['NRIC'], doc['Name'], doc['Position'], doc['Salary'], doc['WorkStatus'], doc['Uid'], doc['email'], doc['password'])).toList();
      }
      for(Employee emp in temp){
        empList.add(emp);
      }
      return Future.value(empList);
    }
    return Future.value([]);
  }

  Future<Employee>login()async{
    List<Employee> empList = await getEmployees();
    for(Employee emp in empList){
      if(emp.email.compareTo(_emailController.text) == 0){
        if(emp.password.compareTo(_passwordController.text) == 0){
          return Future.value(emp);
        }
      }
    }
    return Future.value();
  }
}
