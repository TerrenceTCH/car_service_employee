import 'package:cloud_firestore/cloud_firestore.dart';

class bookingObject {
  String ServiceCentreName;
  Timestamp TimeSlot;
  String LicensePlateNumber;
  String ServiceType;
  String Uid;
  String Status;
  String TimeSlotUid;
  String ServiceBayUid;
  String ServiceCentreUid;
  Timestamp LastUpdateTime;

  bookingObject(this.ServiceCentreName, this.TimeSlot, this.LicensePlateNumber, this.ServiceType, this.Uid, this.Status, this.TimeSlotUid, this.ServiceBayUid, this.ServiceCentreUid, this.LastUpdateTime);

}

class BookingStatus {
  String Status;
  String Description;
  String Indicator;

  BookingStatus(this.Status, this.Description, this.Indicator);
}