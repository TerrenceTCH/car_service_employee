import 'package:car_days_employee/Login.dart';
import 'profileCard.dart';
import 'package:car_days_employee/serviceCentre.dart';
import 'package:car_days_employee/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  List<Employee> empList = [];
  String empServiceCentreId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  void signOut(){
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EmployeeLogin()), (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<Employee?>(
                    future: readEmployee(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        final employee = snapshot.data!;
                        return ProfileCard(employee);
                      }else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: signOut,
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Louis',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
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
                ),

              ],
            ),
          )

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
        if(emp.Uid.compareTo(auth.currentUser!.uid) == 0){
          print(sc.Uid);
          empServiceCentreId = sc.Uid;
        }
        empList.add(emp);
      }

      return Future.value(empList);
    }
    return Future.value([]);
  }

  Future<Employee?> readEmployee() async{
    List<Employee> empList = await getEmployees();

    for(Employee emp in empList){
      if(emp.Uid.compareTo(auth.currentUser!.uid.trim()) == 0){
        return Future.value(emp);
      }
    }
    return Future.value(null);
  }
}
