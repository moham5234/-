import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/user_model.dart';
import '../widgets/HomeButton.dart';
import 'add_appointment_screen.dart';
import 'appointments_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'home_screen_title'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          leading: const BackButton(color: Colors.white),
        ),
        body: Column(
          children: [
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100.r),
                  bottomLeft: Radius.circular(100.r),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "Assets/images/log2.png",
                  width: 130.w,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "welcome".tr(),
                    style: GoogleFonts.cairo(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    user.type == 'admin'
                        ? 'logged_in_as_admin'.tr()
                        : 'logged_in_as_user'.tr(),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      color: user.type == 'admin' ? Colors.green : Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 100.h),
                  CustomHomeButton(
                    label: "view_appointments".tr(),
                    icon: Icons.list_alt,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentsScreen(user: user)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomHomeButton(
                    label: "add_appointment".tr(),
                    icon: Icons.add,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAppointmentScreen(
                                user: user,
                              )),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomHomeButton(
                    label: "logout".tr(),
                    icon: Icons.logout,
                    color: Colors.redAccent,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
