import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_days_employee/bookingObject.dart';
import 'package:car_days_employee/serviceCentre.dart';
import 'package:car_days_employee/user.dart';
import 'package:car_days_employee/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';

class MechanicConfirmBookingDetails extends StatefulWidget {
  const MechanicConfirmBookingDetails({Key? key, required this.booking}) : super(key: key);

  final bookingObject booking;


  @override
  State<MechanicConfirmBookingDetails> createState() => _MechanicConfirmBookingDetailsPageState();
}

class _MechanicConfirmBookingDetailsPageState extends State<MechanicConfirmBookingDetails> {
  TextEditingController serviceCentreController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController selectedServiceTypeController = TextEditingController();
  TextEditingController serviceDateController = TextEditingController();
  TextEditingController bookingStatusController = TextEditingController();
  late Users customer;
  String serviceCentreSelectedValue = '';
  bool selectedServiceDate = false;
  bool selectedServiceCentre = false;
  bool selectedServiceTimeSlot = false;
  bool isInMinorOnly = false;
  bool isInMajorAndMinor = false;
  bool isInMajorAndMinorExtra = false;
  String selectedVehicle = '';
  String selectedTimeSlotUsid='';
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool isTodayOffDay = false;
  final int length = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> serviceTypeAvailable = [];
  List<vehicleObject> vehicles = [];
  List<serviceCentre> serviceCentres = [];
  List<offDays> serviceCentreOffDays = [];
  List<DateTime> DisallowedDates = [];
  List<TimeSlot> chosenServiceCentreAvailableTimeSlots = [];
  List<String> AllowedTime = [];
  late DateTime ServiceDateInDate;
  String selectedTime = '';
  String initialSelectedType = '';
  String Uid = '';
  String initialSelectedTime = '';
  String SelectedServiceBayUid = '';
  String SelectedServiceCentreUid = '';
  String SelectedTimeSlotUid = '';
  String fromOriginalServiceBayUid = '';
  String fromOriginalServiceCentreUid = '';
  String fromOriginalTimeSlotUid = '';
  String initialServiceDateTime = '';
  GlobalKey<FormState> updateBookingFormKey = GlobalKey<FormState>();


  @override
  void initState(){
    selectedServiceTypeController.text = widget.booking.ServiceType;
    initialServiceDateTime = widget.booking.TimeSlot.toDate().toString();
    bookingStatusController.text = widget.booking.Status;
    vehicleController.text = widget.booking.LicensePlateNumber!;
    print('im selectedVehicle ${selectedVehicle}');
    serviceCentreSelectedValue = widget.booking.ServiceCentreName!;
    DateTime mainDateTime = widget.booking.TimeSlot.toDate();
    DateTime dateInDateTime = DateTime(mainDateTime.year, mainDateTime.month, mainDateTime.day, mainDateTime.hour, mainDateTime.minute, mainDateTime.second);
    DateTime timeInDateTime = DateTime(mainDateTime.hour, mainDateTime.minute, mainDateTime.second);
    String dateInString = DateFormat('yyyy-MM-dd').format(dateInDateTime);
    String timeInString = DateFormat('HH:mm:ss').format(dateInDateTime);
    initialSelectedTime = timeInString;
    serviceDateController.text = initialServiceDateTime;
    initialSelectedType = widget.booking.ServiceType!;
    print('im initialSelectedType ${initialSelectedType}');
    Uid = widget.booking.Uid!;
    fromOriginalServiceBayUid = widget.booking.ServiceBayUid!;
    fromOriginalServiceCentreUid = widget.booking.ServiceCentreUid!;
    fromOriginalTimeSlotUid = widget.booking.TimeSlotUid!;
    SelectedServiceBayUid = fromOriginalServiceBayUid;
    SelectedServiceCentreUid = fromOriginalServiceCentreUid;
    SelectedTimeSlotUid = fromOriginalTimeSlotUid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.redAccent.shade100, Colors.blueAccent.shade100]
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 70, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Booking Details!", style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Louis',
                                  color: Colors.black),),
                              InkWell(
                                onTap: () async {
                                  await Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) =>
                                          MyHomePage(title: 'home')), (
                                          route) => false);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFDBE2E7),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      await Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (context) =>
                                              MyHomePage(title: 'home')), (
                                              route) => false);
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF090F13),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: FutureBuilder<List<serviceCentre>>(
                                future: getAllServiceCentres(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    serviceCentres = snapshot.data!;
                                    return ListView(
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 36, 0, 0),
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  0, 3, 0, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 16, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            "Booking Found!",
                                                            style: TextStyle(
                                                                fontFamily: 'Daviton',
                                                                fontSize: 30,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 16, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize
                                                                .max,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: TextFormField(
                                                                  controller: vehicleController,
                                                                  obscureText: false,
                                                                  decoration: InputDecoration(
                                                                    labelText: "Selected vehicle",
                                                                    labelStyle: TextStyle(
                                                                      fontSize: 16,
                                                                      fontFamily: 'Louis',
                                                                      color: Color(0xFF95A1AC),
                                                                    ),
                                                                    hintText: "Enter your vehicle status here.",
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
                                                                  readOnly: true,
                                                                ),
                                                                // DropdownButtonFormField2(
                                                                //   decoration: InputDecoration(
                                                                //     isDense: true,
                                                                //     contentPadding: EdgeInsets
                                                                //         .zero,
                                                                //     border: OutlineInputBorder(
                                                                //       borderRadius: BorderRadius
                                                                //           .circular(
                                                                //           15),
                                                                //     ),
                                                                //     //Add more decoration as you want here
                                                                //     //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                //   ),
                                                                //   value: selectedVehicle,
                                                                //   isExpanded: true,
                                                                //   hint: Text(
                                                                //     'Select Your Vehicle',
                                                                //     style: TextStyle(
                                                                //         fontSize: 14),
                                                                //   ),
                                                                //   iconStyleData: const IconStyleData(
                                                                //     icon: Icon(Icons
                                                                //         .arrow_drop_down,
                                                                //       color: Colors
                                                                //           .black45,),
                                                                //     iconSize: 30,
                                                                //   ),
                                                                //   buttonStyleData: const ButtonStyleData(
                                                                //       height: 60,
                                                                //       padding: const EdgeInsets
                                                                //           .only(
                                                                //           left: 20,
                                                                //           right: 10)),
                                                                //   dropdownStyleData: DropdownStyleData(
                                                                //     decoration: BoxDecoration(
                                                                //       borderRadius: BorderRadius
                                                                //           .circular(
                                                                //           15),
                                                                //     ),
                                                                //   ),
                                                                //   items: vehicles
                                                                //       .map((item) =>
                                                                //       DropdownMenuItem<
                                                                //           String>(
                                                                //         value: item
                                                                //             .LicensePlateNumber,
                                                                //         child: Text(
                                                                //           item
                                                                //               .LicensePlateNumber,
                                                                //           style: const TextStyle(
                                                                //             fontSize: 14,
                                                                //           ),
                                                                //         ),
                                                                //       ))
                                                                //       .toList(),
                                                                //   onChanged: (value) {
                                                                //     selectedVehicle = value.toString();
                                                                //   },
                                                                //   onSaved: (value) {
                                                                //     selectedVehicle =
                                                                //         value
                                                                //             .toString();
                                                                //   },
                                                                // ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 16, 20, 20),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: DropdownButtonFormField2(
                                                              decoration: InputDecoration(
                                                                //Add isDense true and zero Padding.
                                                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.zero,
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                //Add more decoration as you want here
                                                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                              ),
                                                              value: serviceCentreSelectedValue,
                                                              isExpanded: true,
                                                              hint: const Text(
                                                                'Select a service centre.',
                                                                style: TextStyle(fontSize: 14),
                                                              ),
                                                              iconStyleData: const IconStyleData(
                                                                icon : Icon(Icons.arrow_drop_down, color: Colors.black45,),
                                                                iconSize: 30,
                                                              ),
                                                              buttonStyleData: const ButtonStyleData(height : 60, padding: const EdgeInsets.only(left: 20, right: 10)),
                                                              dropdownStyleData : DropdownStyleData(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                              ),
                                                              items: serviceCentres
                                                                  .map((item) =>
                                                                  DropdownMenuItem<String>(
                                                                    value: item.Name,
                                                                    child: Text(
                                                                      item.Name,
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ))
                                                                  .toList(),
                                                              validator: (value) {
                                                                if (value == null) {
                                                                  return 'Please select service centre.';
                                                                }
                                                              },
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  if(selectedServiceCentre == false){
                                                                    selectedServiceCentre = !selectedServiceCentre;
                                                                  }
                                                                  serviceCentreSelectedValue = value.toString();
                                                                });
                                                              },
                                                              onSaved: (value) {

                                                              },
                                                            )
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
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 16, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextField(
                                                            controller: serviceDateController,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              labelText: "Service Date",
                                                              labelStyle: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Louis',
                                                                color: Color(0xFF95A1AC),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFFDBE2E7),
                                                                  width: 2,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .circular(8),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFFDBE2E7),
                                                                  width: 2,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .circular(8),
                                                              ),
                                                              filled: true,
                                                              fillColor: Colors.white70,
                                                              contentPadding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  16, 24, 0, 24),
                                                            ),
                                                            readOnly: true,
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
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 16, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextFormField(
                                                            controller: selectedServiceTypeController,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              labelText: "Selected Service Type",
                                                              labelStyle: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Louis',
                                                                color: Color(0xFF95A1AC),
                                                              ),
                                                              hintText: "Enter your service type here.",
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
                                                            readOnly: true,
                                                          ),
                                                          // DropdownButtonFormField2(
                                                          //   decoration: InputDecoration(
                                                          //     //Add isDense true and zero Padding.
                                                          //     //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                          //     isDense: true,
                                                          //     contentPadding: EdgeInsets
                                                          //         .zero,
                                                          //     border: OutlineInputBorder(
                                                          //       borderRadius: BorderRadius
                                                          //           .circular(15),
                                                          //     ),
                                                          //     //Add more decoration as you want here
                                                          //     //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                          //   ),
                                                          //   value: initialSelectedType,
                                                          //   isExpanded: true,
                                                          //   hint: const Text(
                                                          //     'Select Your Service Type',
                                                          //     style: TextStyle(
                                                          //         fontSize: 14),
                                                          //   ),
                                                          //   iconStyleData: const IconStyleData(
                                                          //     icon: Icon(
                                                          //       Icons.arrow_drop_down,
                                                          //       color: Colors.black45,),
                                                          //     iconSize: 30,
                                                          //   ),
                                                          //   buttonStyleData: const ButtonStyleData(
                                                          //       height: 60,
                                                          //       padding: const EdgeInsets
                                                          //           .only(
                                                          //           left: 20, right: 10)),
                                                          //   dropdownStyleData: DropdownStyleData(
                                                          //     decoration: BoxDecoration(
                                                          //       borderRadius: BorderRadius
                                                          //           .circular(15),
                                                          //     ),
                                                          //   ),
                                                          //   items: serviceTypeAvailable
                                                          //       .map((item) =>
                                                          //       DropdownMenuItem<String>(
                                                          //         value: item,
                                                          //         child: Text(
                                                          //           item,
                                                          //           style: const TextStyle(
                                                          //             fontSize: 14,
                                                          //           ),
                                                          //         ),
                                                          //       ))
                                                          //       .toList(),
                                                          //   validator: (value) {
                                                          //     if (value == null) {
                                                          //       return 'Please select service type.';
                                                          //     }
                                                          //   },
                                                          //   onChanged: (value) {
                                                          //
                                                          //     initialSelectedType =
                                                          //         value.toString();
                                                          //   },
                                                          //   onSaved: (value) {
                                                          //
                                                          //   },
                                                          // ),
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
                                                            controller: bookingStatusController,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              labelText: "Booking Status",
                                                              labelStyle: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Louis',
                                                                color: Color(0xFF95A1AC),
                                                              ),
                                                              hintText: "Booking status here.",
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
                                                            readOnly: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(20, 12, 20, 16),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () async
                                                          {
                                                            await updateBooking();
                                                          },
                                                          child: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              fontFamily: 'Louis',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            minimumSize: null,
                                                            backgroundColor: MaterialStateProperty
                                                                .all<Color>(Colors.cyan),
                                                            foregroundColor: MaterialStateProperty
                                                                .all<Color>(
                                                                Colors.lightBlueAccent),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(15),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .transparent)
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async
                                                          {
                                                            await rejectBooking();
                                                          },
                                                          child: Text(
                                                            "Reject!",
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              fontFamily: 'Louis',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            minimumSize: null,
                                                            backgroundColor: MaterialStateProperty
                                                                .all<Color>(Colors.cyan),
                                                            foregroundColor: MaterialStateProperty
                                                                .all<Color>(
                                                                Colors.lightBlueAccent),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(15),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .transparent)
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
                                    );

                                  }else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                },
                              )

                          ),

                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );

  }


  Map<String, String> bookingInfoToBeEntered(String vehicleChosen, String serviceDate, String serviceCentre, String selectedServiceType) {
    Map<String, String> info = {
      "servicecentrename" : serviceCentre,
      "vehicleLicensePlate" : vehicleChosen,
      "serviceDate" : serviceDate,
      "servicetype" : selectedServiceType
    };

    return info;
  }
  Future<void>getUser() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<Users> dataList = [];
      dataList = snapshot.docs.map((doc) => Users(doc['email'],doc['password'],doc['dateCreated'],doc['userType'],doc['NRIC'],doc['city'],doc['dob'],doc['mail'],doc['name'],doc['phone'],doc['postCode'],doc['state'],doc['Uid'], doc['token'])).toList();
      if(dataList.length > 0){
        for(Users user in dataList){
          List<bookingObject> temp = [];
          QuerySnapshot snapshot = await ref.doc(user.Uid.trim()).collection('booking').get();
          if(snapshot.docs.length > 0){
            temp = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'],doc['LastUpdatedTime'])).toList();
          }
          if(temp.length > 0){
            for(bookingObject b in temp){
              if(b.Uid.trim().compareTo(widget.booking.Uid.trim()) == 0){
                customer = user;
              }
            }
          }
        }

      }
    }
  }

  Future<List<serviceCentre>> getAllServiceCentres() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<serviceCentre> dataList = [];
      dataList = snapshot.docs.map((doc) => serviceCentre(doc['Name'], doc['State'], doc['City'], doc['Street'], doc['Postcode'], doc['Uid'], doc['ContactNumber'])).toList();
      if(dataList.length > 0){
        await getUser();
        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }


  Future<void> updateBooking() async {
    Timestamp time = Timestamp.fromDate(DateTime.now());
    //update booking in user table
    await FirebaseFirestore.instance.collection('users').doc(customer.Uid.trim()).collection('booking').doc(Uid).update(
        {
          "Status":'Confirmed',
          "LastUpdatedTime": time
        }
    ).catchError((error) {
      print(error);
    });

    //update service centre part 1) delete ori first 2) reassign the timeslot 3) then only create new
    await FirebaseFirestore.instance.collection('ServiceCentre').doc(fromOriginalServiceCentreUid.trim()).collection('ServiceBay').doc(fromOriginalServiceBayUid.trim()).collection('TimeSlots').doc(fromOriginalTimeSlotUid.trim()).collection('ServicingList').doc(Uid).delete().then((value) async {
      await FirebaseFirestore.instance.collection('ServiceCentre').doc(fromOriginalServiceCentreUid.trim()).collection('ServiceBay').doc(fromOriginalServiceBayUid.trim()).collection('TimeSlots').doc(fromOriginalTimeSlotUid.trim()).update({
        "Status" : 'Available'
      }).catchError((error) {
        print(error);
      });

    }).catchError((error)
    {
      print(error);
    });

    //get service bay category
    int empCount = 0;
    int seniorCount = 0;
    ServiceBay selectedServiceBay;
    List<Employee> sb = [];
    CollectionReference reference = FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('Employees');
    QuerySnapshot snap = await reference.get();
    if(snap.docs.length > 0){
      sb = snap.docs.map((doc) => Employee(doc['BayInCharge'], doc['NRIC'], doc['Name'], doc['Position'], doc['Salary'], doc['WorkStatus'], doc['Uid'], doc['email'], doc['password'])).toList();
      if(sb.length > 0){
        for(Employee emp in sb){
          if(emp.BayInCharge.compareTo(widget.booking.ServiceBayUid.trim()) == 0){
            empCount++;
            if(emp.Position.compareTo('Senior Mechanic') == 0){
              seniorCount++;
            }
          }
        }
        print('checking empCount ${empCount}');
        print('checking seniorCount ${seniorCount}');
        DocumentReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim());
        DocumentSnapshot snapshot = await ref.get();
        if(snapshot.exists){
          selectedServiceBay = ServiceBay.fromSnapshot(snapshot);
          if(empCount < int.parse(selectedServiceBay.MinNumberOfEmployees)){
            isInMinorOnly = true;
          }
          else if(empCount >= int.parse(selectedServiceBay.MinNumberOfEmployees) && empCount < int.parse(selectedServiceBay.MaxNumberOfEmployees)){
            print('checking im here');
            if(seniorCount > 0){
              isInMajorAndMinor = true;
            }
            else{
              isInMinorOnly = true;
            }
          }
          else if(empCount >= int.parse(selectedServiceBay.MaxNumberOfEmployees)){
            if(seniorCount > 0){
              isInMajorAndMinorExtra = true;
            }
            else{
              isInMinorOnly = true;
            }
          }
        }

      }

    }

    //set new data for new slot service centre part
    await FirebaseFirestore.instance.collection('ServiceCentre').doc(SelectedServiceCentreUid.trim()).collection('ServiceBay').doc(SelectedServiceBayUid.trim()).collection('TimeSlots').doc(SelectedTimeSlotUid.trim()).collection('ServicingList').doc(Uid).set(
        {
          "ServiceCentreName" : widget.booking.ServiceCentreName.trim(),
          "LicensePlateNumber" : widget.booking.LicensePlateNumber.trim(),
          "TimeSlot" : widget.booking.TimeSlot,
          "ServiceType" : widget.booking.ServiceType.trim(),
          "TimeSlotUid" : widget.booking.TimeSlotUid.trim(),
          "ServiceBayUid" : widget.booking.ServiceBayUid.trim(),
          "ServiceCentreUid" : widget.booking.ServiceCentreUid.trim(),
          "Uid" : Uid,
          "Status" : 'Confirmed',
          "LastUpdatedTime": time

        }
    ).then((value) async {
      if(isInMinorOnly == true){
        int MinorCount = 0;
        int MajorCount = 0;
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).collection('ServicingList');
        QuerySnapshot snap = await ref.get();
        List<bookingObject> services = [];
        if(snap.docs.length > 0){
          services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
          for(bookingObject obj in services){
            if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
              MinorCount++;
            }
            else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
              MajorCount++;
            }
          }
          // check the timeslot servicing list have major or not, if have straight return no other services
          if(MajorCount > 0){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
          else if(MinorCount > 0){
            if(MinorCount >= 2){
              await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
                "Status" : 'Full'
              }).catchError((error) {
                print(error);
              });
            }
          }
        }
      }
      else if(isInMajorAndMinor == true){
        int MinorCount = 0;
        int MajorCount = 0;
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).collection('ServicingList');
        QuerySnapshot snap = await ref.get();
        List<bookingObject> services = [];
        if(snap.docs.length > 0){
          services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
          for(bookingObject obj in services){
            if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
              MinorCount++;
            }
            else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
              MajorCount++;
            }
          }

          print('im here to check if MajorCount is = ${MajorCount}');
          print('im here to check if MinorCount is = ${MinorCount}');
          // check the timeslot servicing list have major or not, if have straight return no other services
          if(MajorCount > 0){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
          else if(MinorCount > 0){
            if(MinorCount >= 2){
              await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
                "Status" : 'Full'
              }).catchError((error) {
                print(error);
              });
            }
          }
        }
      }
      else if(isInMajorAndMinorExtra == true){
        int MinorCount = 0;
        int MajorCount = 0;
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).collection('ServicingList');
        QuerySnapshot snap = await ref.get();
        List<bookingObject> services = [];
        if(snap.docs.length > 0){
          services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
          for(bookingObject obj in services){
            if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
              MinorCount++;
            }
            else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
              MajorCount++;
            }
          }
          // check the timeslot servicing list have major or not, if have straight return no other services
          if(MajorCount > 0){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
          else if(MinorCount > 0){
            if(MinorCount >= 3){
              await FirebaseFirestore.instance.collection('ServiceCentre').doc(widget.booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(widget.booking.ServiceBayUid.trim()).collection('TimeSlots').doc(widget.booking.TimeSlotUid.trim()).update({
                "Status" : 'Full'
              }).catchError((error) {
                print(error);
              });
            }
          }
        }
      }
    }).catchError((error) {
      print(error.toString());
    });

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final message = {
      'notification': {
        'title': 'Car Days Service',
        'body': 'Your booking has been confirmed!',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'screen': 'YOUR_SCREEN',
      },
      'to': '${customer.token.trim()}'
    };

    String serverKey = 'AAAAluPopVY:APA91bGf5CmXSPzlNezzHsSkPyRJC1_0_j9dSDT61RKtyKi9kITp_w7D9cA9S-Oa_ho4aqLe34xDKqrwIcPf-MaRSk9oexloeJm_1v19g1bvh28iM4ugQSf31zmKfY7_ngY_BUNlW5JG';
    // Send the message using the FirebaseMessaging API.
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization' : 'key=$serverKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      // Notification sent successfully.
      print('Notification sent.');
    } else {
      // Failed to send notification.
      print('Failed to send notification. Error: ${response.body}');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Update Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) =>MyHomePage(title: 'Employee')), (route) => false);
  }

  Future<void> rejectBooking() async {
    Timestamp time = Timestamp.fromDate(DateTime.now());
    //update booking in user table
    await FirebaseFirestore.instance.collection('users').doc(customer.Uid.trim()).collection('booking').doc(Uid).update(
        {
          "Status":'Rejected',
          "LastUpdatedTime": time
        }
    ).catchError((error) {
      print(error);
    });

    //update service centre part 1) delete ori first 2) reassign the timeslot 3) then only create new
    await FirebaseFirestore.instance.collection('ServiceCentre').doc(fromOriginalServiceCentreUid.trim()).collection('ServiceBay').doc(fromOriginalServiceBayUid.trim()).collection('TimeSlots').doc(fromOriginalTimeSlotUid.trim()).collection('ServicingList').doc(Uid).delete().then((value) async {
      await FirebaseFirestore.instance.collection('ServiceCentre').doc(fromOriginalServiceCentreUid.trim()).collection('ServiceBay').doc(fromOriginalServiceBayUid.trim()).collection('TimeSlots').doc(fromOriginalTimeSlotUid.trim()).update({
        "Status" : 'Available'
      }).catchError((error) {
        print(error);
      });

    }).catchError((error)
    {
      print(error);
    });

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final message = {
      'notification': {
        'title': 'Car Days Service',
        'body': 'Uh oh! Your booking appointment has been rejected.',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'screen': 'YOUR_SCREEN',
      },
      'to': '${customer.token.trim()}'
    };

    String serverKey = 'AAAAluPopVY:APA91bGf5CmXSPzlNezzHsSkPyRJC1_0_j9dSDT61RKtyKi9kITp_w7D9cA9S-Oa_ho4aqLe34xDKqrwIcPf-MaRSk9oexloeJm_1v19g1bvh28iM4ugQSf31zmKfY7_ngY_BUNlW5JG';
    // Send the message using the FirebaseMessaging API.
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization' : 'key=$serverKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      // Notification sent successfully.
      print('Notification sent.');
    } else {
      // Failed to send notification.
      print('Failed to send notification. Error: ${response.body}');
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) =>MyHomePage(title: 'Employee')), (route) => false);
  }







}
