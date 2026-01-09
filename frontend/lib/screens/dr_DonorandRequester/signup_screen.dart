import 'package:flutter/material.dart';
import 'package:test_app/features/auth/data/register/register_service.dart';
import 'package:test_app/screens/signin_screen.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
  
}
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _signupNameCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPassCtrl = TextEditingController();
  final _signupConfirmPassCtrl = TextEditingController();

  bool _signupShowPass = false;
  bool _signupShowConfirm = false;

  @override
  void dispose() {
    _signupNameCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPassCtrl.dispose();
    _signupConfirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final double headerH = height * 0.32;
    final double overlap = height * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: _signupBuildHeader(context, headerH, width, height),
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
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      height * 0.03,
                      width * 0.04,
                      height * 0.03,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.005),
                        _signupBuildForm(context),
                        SizedBox(height: height * 0.02),
                        _signupBuildActions(context),
                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupBuildHeader(BuildContext context, double headerH, double width, double height) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/doctor_header.jpg',
          width: double.infinity,
          height: headerH,
          fit: BoxFit.cover,
        ),
        Container(
          height: headerH,
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned(
          left: width * 0.02,
          top: height * 0.05,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        Positioned(
          left: width * 0.36,
          top: height * 0.055,
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.085,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _signupBuildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            readOnly: false,
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _signupNameCtrl,
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
            readOnly: false,
            label: 'Email',
            hint: 'Enter your email',
            controller: _signupEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.endsWith('@gmail.com')) {
                return 'Email must end with @gmail.com';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          CustomTextField(
            readOnly: false,
            label: 'Password',
            hint: "Enter your password",
            controller: _signupPassCtrl,
            isPassword: true,
            obscure: _signupShowPass,
            onToggleVisibility: () => setState(() => _signupShowPass = !_signupShowPass),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              
              return null;
            },
          ),
          const SizedBox(height: 14),
          CustomTextField(
            readOnly: false,
            label: 'Confirm Password',
            hint: "Enter your confirm password",
            controller: _signupConfirmPassCtrl,
            isPassword: true,
            obscure: _signupShowConfirm,
            onToggleVisibility: () => setState(() => _signupShowConfirm = !_signupShowConfirm),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your confirm password';
              }
              if (value != _signupPassCtrl.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _signupBuildActions(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Column(
      children: [
        SizedBox(
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
            onPressed: _signupOnCreatePressed,
            child: const Text(
              'Create',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Poppins'),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: const [
            Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('OR', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),
        SocialButton(
          icon: Image.asset('assets/images/google_icon_image.jpg', height: 24, width: 24),
          text: 'Sign in with Google',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        SocialButton(
          icon: Image.asset('assets/images/facebook_icon_image.jpg', height: 24, width: 24),
          text: 'Sign in with Facebook',
          onPressed: () {},
        ),
      ],
    );
  }

  Future<void> _signupOnCreatePressed() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await RegisterService().register(
        fullName: _signupNameCtrl.text.trim(),
        email: _signupEmailCtrl.text.trim(),
        password: _signupPassCtrl.text.trim(),
        confirmedPassword: _signupConfirmPassCtrl.text.trim(),
      );

      if (!mounted) return;

      _signupToast(context, 'Account created successfully!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      _signupToast(context, ('Invalid Information'));
    }
  }


  void _signupToast(BuildContext context, String msg) {
    if(msg== 'Account created successfully!'){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),backgroundColor: Colors.green));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),backgroundColor: Colors.red));
    }
  }
  
}
