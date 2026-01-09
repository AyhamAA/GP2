import 'package:flutter/material.dart';
import 'package:test_app/screens/Admin/admin_notification_screen.dart';
import '../../core/storage/user_storage.dart';
import '../../features/auth/data/adminhome/admin_donation_request_model.dart';
import '../../features/auth/data/adminhome/admin_home_service.dart';
import '../../features/auth/data/adminhome/admin_take_donation_request_model.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<AdminDonationRequestModel> _requests = [];
  List<AdminTakeDonationRequestModel> _takerequests = [];
  List<AdminDonationRequestModel> get equipmentDonations =>
      _requests.where((r) => r.type == 'Equipment').toList();

  List<AdminDonationRequestModel> get medicineDonations =>
      _requests.where((r) => r.type == 'Medicine').toList();

  List<AdminTakeDonationRequestModel> get equipmentTakeRequests =>
      _takerequests.where((r) => r.type == 'Equipment').toList();

  List<AdminTakeDonationRequestModel> get medicineTakeRequests =>
      _takerequests.where((r) => r.type == 'Medicine').toList();

  bool isDonationActive = true;
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadAllData();
  }
  Future<void> _loadAllData() async {
    _requests.clear();
    _takerequests.clear();

    await Future.wait([
      _loadEquipmentUploadRequests(),
      _loadMedicineUploadRequests(),
      _loadEquipmentTakeRequests(),
      _loadMedicineTakeRequests(),
    ]);
  }


  Future<void> _loadEquipmentUploadRequests() async {
    final data = await AdminHomeService().getPendingEquipmentRequests();
    print('Upload equipment: ${data.length}');
    if (!mounted) return;
    setState(() {
      _requests.addAll(data);
    });
  }

  Future<void> _loadMedicineUploadRequests() async {
    final data = await AdminHomeService().getPendingMedicineRequests();
    print('Upload medicine: ${data.length}');
    if (!mounted) return;
    setState(() {
      _requests.addAll(data);
    });
  }
  Future<void> _loadEquipmentTakeRequests() async {
    final data = await AdminHomeService().getPendingTakeEquipmentRequests();
    print('Take equipment: ${data.length}');
    if (!mounted) return;
    setState(() {
      _takerequests.addAll(data);
    });
  }

  Future<void> _loadMedicineTakeRequests() async {
    final data = await AdminHomeService().getPendingTakeMedicineRequests();
    print('Take medicine: ${data.length}');
    if (!mounted) return;
    setState(() {
      _takerequests.addAll(data);
    });
  }
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(width),
              SizedBox(height: height * 0.02),
              _buildSearchBar(width, height),
              SizedBox(height: height * 0.02),
              _buildButtons(width, height),
              SizedBox(height: height * 0.03),
              _buildSectionTitle("Medical equipment"),
              SizedBox(height: height * 0.015),
              _buildMedicalEquipment(width, height),
              SizedBox(height: height * 0.03),
              _buildSectionTitle("Medicines donations"),
              SizedBox(height: height * 0.015),
              _buildmedicinesList(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "☀️ Good Morning",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              _fullName.isEmpty ? '...' : _fullName,
              style: TextStyle(
                fontSize: width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            InkWell(
              child: const Icon(Icons.notifications_none_rounded, size: 30),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AdminNotificationScreen(),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(double width, double height) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height * 0.06,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 2),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      filled: false,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: width * 0.03),
        Container(
          height: height * 0.06,
          width: height * 0.06,
          decoration: BoxDecoration(
            color: const Color(0xFF34AFB7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildActionButton("Donation", isDonationActive, () {
          setState(() {
            isDonationActive = !isDonationActive;
          });
        }),
        SizedBox(width: width * 0.04),
        _buildActionButton("Request", !isDonationActive, () {
          setState(() {
            isDonationActive = !isDonationActive;
          });
        }),
      ],
    );
  }

  Widget _buildActionButton(String text, bool isActive, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF34AFB7) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF34AFB7), width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF34AFB7),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMedicalEquipment(double width, double height) {
    return SizedBox(
      height: height * 0.23,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (isDonationActive)
            ? equipmentDonations.length
            : equipmentTakeRequests.length,
        itemBuilder: (context, index) {
          return Container(
            width: width * 0.55,
            margin: EdgeInsets.only(right: width * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    isDonationActive
                        ? 'assets/images/wheelchair.png'
                        : 'assets/images/patientbed.jpg',
                    height: height * 0.15,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (isDonationActive)
                              ? equipmentDonations[index].itemName
                              : equipmentTakeRequests[index].itemName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Qty: ${(isDonationActive)
                              ? equipmentDonations[index].quantity
                              : equipmentTakeRequests[index].quantity}',

                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (isDonationActive)
                              ? equipmentDonations[index].userName
                              : equipmentTakeRequests[index].userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          (isDonationActive)
                              ? equipmentDonations[index].userEmail
                              : equipmentTakeRequests[index].userEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close_rounded),
                            color: Colors.red,
                            iconSize: 20,
                            onPressed: () {
                              final item = isDonationActive
                                  ? equipmentDonations[index]
                                  : equipmentTakeRequests[index];

                              setState(() {
                                if (isDonationActive) {
                                  _requests.remove(item);
                                } else {
                                  _takerequests.remove(item);
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 6),

                        Container(
                          width: 36,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.check_circle),
                            color: Colors.green,
                            iconSize: 20,
                            onPressed: () {
                              final item = isDonationActive
                                  ? equipmentDonations[index]
                                  : equipmentTakeRequests[index];

                              setState(() {
                                if (isDonationActive) {
                                  _requests.remove(item);
                                } else {
                                  _takerequests.remove(item);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildmedicinesList(double width, double height) {
    return Expanded(
      child: ListView.builder(
        itemCount: (isDonationActive)
            ? medicineDonations.length
            : medicineTakeRequests.length,
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: height * 0.015),
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: const Color(0xFF34AFB7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medication_liquid, color: Colors.white),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (isDonationActive)
                              ? medicineDonations[index].itemName
                              : medicineTakeRequests[index].itemName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Qty: ${(isDonationActive)
                              ? medicineDonations[index].quantity
                              : medicineTakeRequests[index].quantity}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),

                        Text(
                          (isDonationActive)
                              ? medicineDonations[index].userName
                              : medicineTakeRequests[index].userName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          (isDonationActive)
                              ? medicineDonations[index].userEmail
                              : medicineTakeRequests[index].userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close_rounded),
                        color: Colors.red,
                        iconSize: 20,
                        onPressed: () {
                          final item = isDonationActive
                              ? medicineDonations[index]
                              : medicineTakeRequests[index];

                          setState(() {
                            if (isDonationActive) {
                              _requests.remove(item);
                            } else {
                              _takerequests.remove(item);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      width: 36,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check_circle),
                        color: Colors.green,
                        iconSize: 20,
                        onPressed: () {
                          final item = isDonationActive
                              ? medicineDonations[index]
                              : medicineTakeRequests[index];

                          setState(() {
                            if (isDonationActive) {
                              _requests.remove(item);
                            } else {
                              _takerequests.remove(item);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadUser() async {
    final name = await UserStorage.getFullName();
    if (!mounted) return;
    setState(() {
      _fullName = name ?? '';
    });
  }
}
