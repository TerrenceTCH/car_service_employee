
import 'package:car_days_employee/MechanicConfirmBookingDetection.dart';
import 'package:car_days_employee/serviceCentre.dart';
import 'package:flutter/material.dart';

import 'MechanicBookingDetection.dart';
import 'MechanicDetection.dart';


class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);



  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 50),
                child: Text(
                  'Employee Place',
                  style: TextStyle(
                      fontSize: 42,
                      fontFamily: 'Daviton',
                      color: Colors.black
                  ),
                ),
              ),
            ),
            Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: ButtonTable(
                    buttonLabels: [
                      ["detection", "detectionbooking"],
                      ["detectionconfirmationbooking", "comingsoon"],
                    ],
                    onPressed: (int row, int col){
                      if(row == 0 && col == 0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MechanicDetection()),);
                      }
                      else if(row == 0 && col == 1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MechanicBookingDetection()),);
                      }
                      else if(row == 1 && col == 0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MechanicConfirmBookingDetection()),);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                    },
                  ),
                )
            ),
          ],
        ),

      ),
    );
  }
}

class ButtonTable extends StatelessWidget {
  final List<List<String>> buttonLabels;
  final void Function(int row, int col) onPressed;
  Map<String, IconData> icons = {
    'detection': Icons.camera_alt_outlined,
    'contact': Icons.phone_callback,
    'comingsoon': Icons.star_border,
    'addvehicle': Icons.add,
    'checkbooking': Icons.car_repair,
    'detectionbooking': Icons.camera_alt_outlined,
    'detectionconfirmationbooking' : Icons.check
    // add more mappings here
  };
  Map<String, String> labels = {
    'detection': 'Car Plate Detection',
    'contact': 'Contact us now!',
    'comingsoon': 'Coming soon',
    'addvehicle': 'Add new Vehicle',
    'checkbooking' : 'Check booking',
    'detectionbooking' : 'Check in vehicle',
    'detectionconfirmationbooking' : 'Confirm booking'
    // add more mappings here
  };

  ButtonTable({required this.buttonLabels, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.transparent),
      children: buttonLabels.asMap().map((rowIndex, row) {
        return MapEntry(
          rowIndex,
          TableRow(
            children: row.asMap().map((colIndex, label) {
              return MapEntry(
                colIndex,
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.black)
                          ),
                        ),
                      ),
                      onPressed: () {
                        onPressed(rowIndex, colIndex);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Icon(icons[label]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              labels[label]!,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).values.toList(),
          ),
        );
      }).values.toList(),
    );
  }
}

