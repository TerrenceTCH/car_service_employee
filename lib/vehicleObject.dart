class vehicleObject {
  String NRIC;
  String Model;
  String Status;
  final String Brand;
  final String Condition;
  final String LicensePlateNumber;
  String Uid;

  vehicleObject(this.NRIC, this.Model, this.Brand, this.Condition, this.LicensePlateNumber,this.Status,this.Uid);


}

class vehicleCondition {
  String Name;
  String Description;

  vehicleCondition(this.Name, this.Description);
}