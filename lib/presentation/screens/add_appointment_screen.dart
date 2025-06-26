import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/models/user_model.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment/appointment_bloc.dart';
import '../bloc/appointment/appointment_event.dart';
import '../bloc/appointment/appointment_state.dart';
import '../widgets/UserTextField.dart';
import 'appointments_screen.dart';

class AddAppointmentScreen extends StatefulWidget {
  final AppointmentEntity? existingAppointment;
  final UserModel user;

  const AddAppointmentScreen(
      {super.key, this.existingAppointment, required this.user});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  late final TextEditingController _dateTimeController;

  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    _dateTimeController = TextEditingController();

    if (widget.existingAppointment != null) {
      _nameController.text = widget.existingAppointment!.name;
      _notesController.text = widget.existingAppointment!.phone;
      _selectedDateTime = widget.existingAppointment!.dateTime;
      _updateDateTimeController();
    }
  }

  void _updateDateTimeController() {
    if (_selectedDateTime != null) {
      final formatter = DateFormat('yyyy-MM-dd HH:mm');
      _dateTimeController.text = formatter.format(_selectedDateTime!);
    } else {
      _dateTimeController.text = '';
    }
  }

  void _pickDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _updateDateTimeController();
        });
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("datetime_required".tr())),
      );
      return;
    }

    final bloc = context.read<AppointmentBlocs>();
    if (widget.existingAppointment != null) {
      bloc.add(UpdateAppointmentEvent(
        id: widget.existingAppointment!.id!,
        name: _nameController.text.trim(),
        phone: _notesController.text.trim(),
        dateTime: _selectedDateTime!,
      ));
    } else {
      bloc.add(AddAppointmentEvent(
        name: _nameController.text.trim(),
        phone: _notesController.text.trim(),
        dateTime: _selectedDateTime!,
      ));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AppointmentsScreen(user: widget.user)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingAppointment != null
              ? "edit_appointment".tr()
              : "add_appointment".tr(),
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  label: "nots_label".tr(),
                  controller: _notesController,
                  icon: Icons.notes,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "nots_required".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: AbsorbPointer(
                    child: UserTextField(
                      label: "datetime_label".tr(),
                      controller: _dateTimeController,
                      icon: Icons.calendar_today,
                      validator: (_) {
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      widget.existingAppointment != null
                          ? "update_button".tr()
                          : "save_button".tr(),
                      style: GoogleFonts.cairo(
                          fontSize: 18.sp, color: Colors.white),
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
