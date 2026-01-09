import 'package:flutter/material.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/donate_button_to_form.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/my_equipment_donations.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/my_medicine_donations.dart';

class DonorItemsList extends StatelessWidget {
  const DonorItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DonateHintCard(),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "My Equipment Donations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: MyEquipmentDonationList()),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "My Medicine Donations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: MyMedicineDonationList()),
      ],
    );
  }
}
