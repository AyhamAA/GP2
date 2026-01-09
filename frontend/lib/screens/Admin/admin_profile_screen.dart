import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/widgets/custom_text_field.dart';

import '../../features/auth/data/Profile/profiel_service.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  final _adminProfileNameCtrl = TextEditingController();
  final _adminProfileEmailCtrl = TextEditingController();
  File? _selectedImage;
  String? _profileImageUrl;
  /*final _adminProfileOldPassCtrl = TextEditingController();
  final _adminProfileNewPassCtrl = TextEditingController();
  final _adminProfileConfirmPassCtrl = TextEditingController();*/
  /* 
  bool _adminProfileShowOldPass = false;
  bool _adminProfileShowNewPass = false;
  bool _adminProfileShowConfirm = false;
*/
  @override
  void dispose() {
    _adminProfileNameCtrl.dispose();
    _adminProfileEmailCtrl.dispose();
    /*_adminProfileOldPassCtrl.dispose();
    _adminProfileNewPassCtrl.dispose();
    _adminProfileConfirmPassCtrl.dispose();*/
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    double headerH = height * 0.39;
    double overlap = height * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: _profileBuildHeader(context, headerH, width, height),
          ),
          Positioned(
            top: headerH - overlap,
            left: 0,
            right: 0,
            bottom: 0,

            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              clipBehavior: Clip.antiAlias,

              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      const SizedBox(height: 5),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            width * 0.04,
                            height * 0.01,
                            width * 0.04,
                            height * 0.03,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.005),
                              _profileBuildForm(context),
                              SizedBox(height: height * 0.31),
                              _profileBuildActions(context),
                              SizedBox(height: height * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileBuildHeader(
    BuildContext context,
    double headerH,
    double width,
    double height,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(height: headerH, color: Color(0xFF34AFB7)),
        Positioned(
          left: width * 0.38,
          top: height * 0.055,
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.080,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Positioned(
          bottom: height * 0.075,
          child: GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: width * 0.45,
                  height: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 4),
                    image: DecorationImage(
                      image: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_profileImageUrl != null
                          ? NetworkImage(
                        '$_profileImageUrl?t=${DateTime.now().millisecondsSinceEpoch}',
                      )
                          : const AssetImage('assets/images/no_profile_picture.jpg')
                      ) as ImageProvider,

                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 6,
                  bottom: 6,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileBuildForm(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 5,),
          CustomTextField(
            readOnly: false,
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _adminProfileNameCtrl,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          CustomTextField(
            readOnly: true,
            label: 'Email',
            hint: 'Enter your email',
            controller: _adminProfileEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.endsWith('@medshare.jo')) {
                return 'Email must end with @medshare.jo';
              }
              return null;
            },
          ),
          /*
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Old Password',
            controller: _adminProfileOldPassCtrl,
            isPassword: true,
            obscure: _adminProfileShowOldPass,
            onToggleVisibility: () =>
                setState(() => _adminProfileShowOldPass = !_adminProfileShowOldPass),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your old password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'New Password',
            controller: _adminProfileNewPassCtrl,
            isPassword: true,
            obscure: _adminProfileShowNewPass,
            onToggleVisibility: () =>
                setState(() => _adminProfileShowNewPass = !_adminProfileShowNewPass),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Confirm Password',
            controller: _adminProfileConfirmPassCtrl,
            isPassword: true,
            obscure: _adminProfileShowConfirm,
            onToggleVisibility: () =>
                setState(() => _adminProfileShowConfirm = !_adminProfileShowConfirm),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your confirm password';
              }
              if (value != _adminProfileNewPassCtrl.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),*/
        ],
      ),
    );
  }

  Widget _profileBuildActions(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.white,
        ),
        onPressed: _profileOnCreatePressed,
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _profileOnCreatePressed() async {
    if (!_formkey.currentState!.validate()) return;
    try {
      MultipartFile? image;

      if (_selectedImage != null) {
        image = await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: 'profile.jpg',
        );
      }

      await AdminProfileService().updateProfile(
        fullName: _adminProfileNameCtrl.text.trim(),
        email: _adminProfileEmailCtrl.text.trim(),
        image: image,
      );
      await _loadProfile();
      setState(() {
        _selectedImage = null;
      });

      if (!mounted) return;
      _profileToast(context,'Profile updated successfully!');
    } catch (e) {
      if (!mounted) return;

      _profileToast(context, 'Failed to update profile');
    }

  }


  void _profileToast(BuildContext context, String msg) {
    if (msg == 'Profile updated successfully!') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _loadProfile() async {
    final profile = await AdminProfileService().getProfile();

    setState(() {
      _adminProfileNameCtrl.text = profile.fullName;
      _adminProfileEmailCtrl.text = profile.email;

      _profileImageUrl = profile.profileImageUrl != null
          ? 'http://10.0.2.2:5149/${profile.profileImageUrl}'
          : null;
    });
  }

}