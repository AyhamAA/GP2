import 'package:flutter/material.dart';
//DONOR TAB
enum DonationStatus {
  pending,
  approved,
  declined,
}

class MyEquipmentRequests {
  final String name;
  final IconData icon;
  final DonationStatus status;

  MyEquipmentRequests({
    required this.name,
    required this.icon,
    required this.status,
  });
}

class MyEquipmentRequestsList extends StatelessWidget {
  MyEquipmentRequestsList({super.key});

  /// التبرعات اللي اليوزر عملها ونزلت على التطبيق
  final List<MyEquipmentRequests> myEquipmentRequests = [
    MyEquipmentRequests(
      name: "Patient bed",
      icon: Icons.bed,
      status: DonationStatus.approved,
    ),
    MyEquipmentRequests(
      name: "Crutch",
      icon: Icons.accessibility,
      status: DonationStatus.pending,
    ),
    MyEquipmentRequests(
      name: "Wheelchair",
      icon: Icons.wheelchair_pickup_outlined,
      status: DonationStatus.declined,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (myEquipmentRequests.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "You haven't donated any items yet.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ...myEquipmentRequests.map(
            (donation) => _MyEquipmentRequestsTile(donation: donation),
          ),
        ],
      ),
    );
  }
}

class _MyEquipmentRequestsTile extends StatelessWidget {
  final MyEquipmentRequests donation;

  const _MyEquipmentRequestsTile({required this.donation});

  @override
  Widget build(BuildContext context) {
    late final String statusText;
    late final Color statusColor;
    late final IconData statusIcon;

    switch (donation.status) {
      case DonationStatus.approved:
        statusText = "Approved";
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case DonationStatus.pending:
        statusText = "Pending approval";
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_bottom;
        break;
      case DonationStatus.declined:
        statusText = "Declined";
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Color(0xFF34AFB7).withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(donation.icon, color: Color(0xFF34AFB7)),
          ),
          const SizedBox(width: 12),

          /// NAME + STATUS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donation.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// STATUS ICON
          Icon(
            statusIcon,
            color: statusColor,
            size: 20,
          ),
        ],
      ),
    );
  }
  }