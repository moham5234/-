import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/user_model.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment/appointment_bloc.dart';
import '../bloc/appointment/appointment_event.dart';
import '../screens/add_appointment_screen.dart';



class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final UserModel user;

  const AppointmentCard({super.key, required this.appointment, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.15),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.deepPurple, size: 24.sp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AppointmentBlocs>(),
                          child: AddAppointmentScreen(
                            existingAppointment: appointment,
                            user: user,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (user.type == 'admin')
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                    onPressed: () => _confirmDelete(context, appointment),
                  ),
                const Spacer(),
                Container(
                  width: 180.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    appointment.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.deepPurple,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildInfoText('📅 التاريخ:  ${DateFormat('yyyy-MM-dd').format(appointment.dateTime)}'),
            _buildInfoText('⏰ الوقت:  ${DateFormat('HH:mm').format(appointment.dateTime)}'),
            _buildInfoText(' ملاحظات:  ${appointment.phone}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        textAlign: TextAlign.right,
      ),
    );
  }
}

void _confirmDelete(BuildContext context, AppointmentEntity appointment) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      title: Text("confirm_delete_title".tr(), style: TextStyle(fontSize: 18.sp)),
      content: Text("confirm_delete_message".tr(), style: TextStyle(fontSize: 16.sp)),
      actions: [
        TextButton(
          child: Text("cancel".tr(), style: TextStyle(fontSize: 14.sp)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("delete".tr(), style: TextStyle(color: Colors.red, fontSize: 14.sp)),
          onPressed: () {
            context.read<AppointmentBlocs>().add(DeleteAppointmentsEvent(appointment.id!));
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
