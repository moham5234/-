import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'injection.dart';
import 'presentation/app/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupInjection();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'Assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AppWrapper(),
    ),
  );
}
