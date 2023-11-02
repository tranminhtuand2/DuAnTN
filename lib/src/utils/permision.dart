import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions(List<Permission> permissions) async {
  bool allGranted = true;

  for (var permission in permissions) {
    PermissionStatus status = await permission.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await permission.request();
      // log("check permission");
      if (!newStatus.isGranted) {
        allGranted = false;
        break; // Ngừng kiểm tra nếu có ít nhất một quyền bị từ chối
      }
    }
  }

  return allGranted;
}
