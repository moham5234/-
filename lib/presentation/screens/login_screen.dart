import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme_mode.dart';
import '../../data/datasources/local_data_source.dart';
import '../widgets/UserTextField.dart';
import 'home_screen.dart';
import 'register_user_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void _login() async {
      if (!_formKey.currentState!.validate()) return;

      final dbHelper = LocalDataSource();
      final success = await dbHelper.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final snackBar = SnackBar(
        content: Text(
          success != null ? 'login_success'.tr() : 'login_failed'.tr(),
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: success != null ? Colors.green : Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (success != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: success)),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "login_screen_title".tr(),
          style: GoogleFonts.cairo(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.language, color: Colors.white, size: 30),
          onPressed: () {
            if (context.locale.languageCode == 'ar') {
              context.setLocale(const Locale('en'));
            } else {
              context.setLocale(const Locale('ar'));
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, size: 30, color: Colors.black),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Text(
                  "welcome".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "login_to_account".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.h),
                UserTextField(
                  label: "email_label".tr(),
                  controller: emailController,
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'email_required'.tr();
                    }
                    if (!value.contains('@')) {
                      return 'email_invalid'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                UserTextField(
                  label: "password_label".tr(),
                  controller: passwordController,
                  icon: Icons.lock,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password_required'.tr();
                    }
                    if (value.length < 6) {
                      return 'password_short'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _login,
                    child: Text(
                      "login_button".tr(),
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterUserScreen()),
                    );
                  },
                  child: Text(
                    'no_account'.tr(),
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
