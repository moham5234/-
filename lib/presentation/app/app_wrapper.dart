import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/permission_handler.dart';
import '../../core/theme_mode.dart';

import '../bloc/appointment/appointment_bloc.dart';
import '../bloc/appointment/appointment_event.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import 'my_app.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await requestNotificationPermission();
    if (!granted) {
      debugPrint('❌ إشعارات مرفوضة');
    }
    setState(() {
      _permissionGranted = granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionGranted == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_permissionGranted == false) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Text("Notification permission is required")),
        ),
      );
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(
          create: (_) => GetIt.instance<AppointmentBlocs>()..add(LoadAppointments()),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<UserBloc>()..add(LoadUsers()),
        ),
      ],
      child: const MyApp(),
    );
  }
}
