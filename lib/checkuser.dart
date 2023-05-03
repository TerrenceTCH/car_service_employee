
import 'package:car_days_employee/homePage.dart';
import 'package:car_days_employee/main.dart';
import 'package:car_days_employee/serviceCentre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class checkuser extends StatefulWidget {
  const checkuser({Key? key}) : super(key: key);

  @override
  State<checkuser> createState() => _checkuserState();
}

class _checkuserState extends State<checkuser> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child : FutureBuilder<List<Employee>>(
          future: getEmployees(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<Employee> empList = snapshot.data!;
              print(empList.length);
              for(Employee emp in empList){
                if(emp.Uid.compareTo(auth.currentUser!.uid.trim()) == 0){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Employee',)), (route) => false);
                  });

                }
              }
              return Text('Please log in to the user panel.');
            }else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
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
      QuerySnapshot snap = await ref.doc(sc.Uid.trim()).collection('Employees').get();
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
}


