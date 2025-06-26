import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../widgets/UserTextField.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final passwordController = TextEditingController();
  final typeController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
            AddUsersEvent(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: passwordController.text.trim(),
              type: typeController.text.trim(),
            ),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "register_user_title".tr(),
          style: GoogleFonts.cairo(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Text(
                  "create_account".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "enter_info_prompt".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.h),
                UserTextField(
                  label: "name_label".tr(),
                  controller: _nameController,
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "name_required".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                UserTextField(
                  label: "email_label".tr(),
                  controller: _emailController,
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "email_required".tr();
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return "invalid_email".tr();
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
                    if (value == null || value.isEmpty) {
                      return "password_required".tr();
                    } else if (value.length < 6) {
                      return "password_too_short".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                UserTextField(
                  label: "user_type_label".tr(),
                  controller: typeController,
                  icon: Icons.admin_panel_settings,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "user_type_required".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40.h),
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
                    onPressed: _submit,
                    child: Text(
                      "register_button".tr(),
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
