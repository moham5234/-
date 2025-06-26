import 'package:permission_handler/permission_handler.dart';

Future<bool> requestNotificationPermission() async {
  if (await Permission.notification.isGranted) {
    return true;
  } else {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
