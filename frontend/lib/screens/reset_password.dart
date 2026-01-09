import 'package:flutter/material.dart';
import 'package:test_app/widgets/custom_text_field.dart';
import '../features/auth/data/resetpassowrd/reset_password_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final resetEmailController = TextEditingController();
  bool _showOldPass = false;
  bool _showNewPass = false;
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  @override
  void dispose() {
    resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Reset password", style: TextStyle(fontSize: 24)),
        backgroundColor: Color(0xFF34AFB7),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 14),
              CustomTextField(
                readOnly: false,
                label: 'Old Password',
                controller: _oldPassCtrl,
                isPassword: true,
                obscure: _showOldPass,
                onToggleVisibility: () =>
                    setState(() => _showOldPass = !_showOldPass),
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
                readOnly:false,
                label: 'New Password',
                controller: _newPassCtrl,
                isPassword: true,
                obscure: _showNewPass,
                onToggleVisibility: () =>
                    setState(() => _showNewPass = !_showNewPass),
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
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _onResetPasswordPressed();
                },
                child: const Text("Reset Password", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _onResetPasswordPressed() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ResetPasswordService().resetPassword(
        oldPassword: _oldPassCtrl.text.trim(),
        newPassword: _newPassCtrl.text.trim(),
      );

      if (!mounted) return;

      _showToast(context, 'Password updated successfully!');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showToast(
        context,
        'Incorrect old password',
      );
    }
  }
  void _showToast(BuildContext context, String msg) {
    if (msg == 'Password updated successfully!') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }

}
