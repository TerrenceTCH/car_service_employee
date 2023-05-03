import 'package:car_days_employee/serviceCentre.dart';
import 'package:car_days_employee/user.dart';
import 'package:flutter/material.dart';


class ProfileCard extends StatelessWidget {
  final Employee _profile;

  ProfileCard(this._profile);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('${_profile.Name}'),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('NRIC: ${_profile.NRIC}'),
            ),
          ),
        ),
      ),
    );
  }
}
