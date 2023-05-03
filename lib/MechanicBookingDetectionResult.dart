import 'package:car_days_employee/MechanicBookingDetails.dart';
import 'package:car_days_employee/user.dart';
import 'package:car_days_employee/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'bookingObject.dart';
class MechanicBookingDetectionResult extends StatefulWidget {
  const MechanicBookingDetectionResult({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  State<MechanicBookingDetectionResult> createState() => _MechanicBookingDetectionResultState();
}

class _MechanicBookingDetectionResultState extends State<MechanicBookingDetectionResult> {
  String? CarPlate;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState()
  {
    super.initState();
    CarPlate = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Container(
          padding: EdgeInsets.all(100.0),
          child: Column(
            children: [
              Text(
                CarPlate!,
                style: TextStyle(
                    fontSize: 50
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await checkFormat();
                  },
                  child: Text('Proceed to confirm vehicle info')
              ),

            ],
          ),
        )
    );
  }

  Future<void> checkFormat() async {
    CarPlate = CarPlate?.trim();
    CarPlate = CarPlate?.toUpperCase();
    CarPlate = CarPlate?.replaceAll(' ', '');
    bookingObject booking = await getBookingById(CarPlate!);
    if(booking == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No booking found!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      CarPlate = CarPlate?.trim();
      CarPlate = CarPlate?.toUpperCase();
      CarPlate = CarPlate?.replaceAll(' ', '');

      print('imhere in mechanic ${booking.Uid}');
      //RegExp licensePattern = RegExp(r'^[a-zA-Z]{1,3}\d{1,4}[a-zA-Z]$');
      _showSuccessDialog(context, booking);


    });
  }

  Future<void> _showSuccessDialog(BuildContext context, bookingObject obj) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed with detected car plate'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Confirm vehicle with car plate : <$CarPlate> .',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) => MechanicBookingDetails(booking: obj)), (route) => false);
                    // do something when the button is pressed
                  },
                  child: const Text('Check Booking'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bookingObject> getBookingById(String carPlate) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<Users> dataList = [];
      List<bookingObject> bookList = [];
      dataList = snapshot.docs.map((doc) => Users(doc['email'],doc['password'],doc['dateCreated'],doc['userType'],doc['NRIC'],doc['city'],doc['dob'],doc['mail'],doc['name'],doc['phone'],doc['postCode'],doc['state'],doc['Uid'],doc['token'])).toList();
      if(dataList.length > 0){
        for(Users user in dataList){
          List<bookingObject> temp = [];
          QuerySnapshot snapshot = await ref.doc(user.Uid.trim()).collection('booking').get();
          if(snapshot.docs.length > 0){
            temp = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
          }
          if(temp.length > 0){
            for(bookingObject b in temp){
              if(b.LicensePlateNumber.compareTo(carPlate.trim()) == 0){
                return Future.value(b);
              }
            }
          }

        }
      }

    }
    return Future.value(null);

  }

  Future<void> _showFailDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Detection'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Detected text does not match Car Plate Pattern! Are you sure you wanna proceed?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) => addVehicle(detectedCarPlate: CarPlate)), (route) => false);
                      },
                      child: const Text('Yes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // do something when the button is pressed
                      },
                      child: const Text('No'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


