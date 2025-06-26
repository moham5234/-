import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/user_model.dart';

import '../bloc/appointment/appointment_bloc.dart';
import '../bloc/appointment/appointment_event.dart';
import '../bloc/appointment/appointment_state.dart';

import '../widgets/AppointmentCard.dart';

class AppointmentsScreen extends StatefulWidget {
  final UserModel user;

  const AppointmentsScreen({super.key, required this.user});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<AppointmentBlocs>().add(LoadAppointments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "appointments_screen_title".tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'search_hint'.tr(),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ),
                label: Text(
                  "export_pdf".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: Colors.deepPurple),
                onPressed: () {
                  context.read<AppointmentBlocs>().add(
                        ExportAppointmentsToPDFEvent(
                          title: "جدول المواعيد",
                          date: DateTime.now(),
                        ),
                      );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<AppointmentBlocs, AppointmentsState>(
                builder: (context, state) {
                  print("🟣 الحالة الحالية: $state");

                  if (state is AppointmentsLoaded) {
                    print("🟢 عدد المواعيد: ${state.appointments.length}");
                    final filtered = state.appointments
                        .where((a) => a.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    print("🔵 بعد الفلترة: ${filtered.length}");

                    if (filtered.isEmpty) {
                      return Center(child: Text("no_appointments".tr()));
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return AppointmentCard(
                          appointment: filtered[index],
                          user: widget.user,
                        );
                      },
                    );
                  }

                  if (state is AppointmentError) {
                    return Center(child: Text("خطأ: ${state.message}"));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
