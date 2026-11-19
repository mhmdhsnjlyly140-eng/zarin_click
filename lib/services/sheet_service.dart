import 'dart:convert';
import 'package:gsheets/gsheets.dart';

class SheetService {
  // ⚠️ اینجا متن Base64 که از فایل JSON ساختی رو پیست کن
  static const String _base64Key = 'ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAic2F2dnktcGFyc2VyLTUxNTIxOS10MSIsCiAgInByaXZhdGVfa2V5X2lkIjogImVlNmQ3MjE5MTNlMGUzMzIwYzY1Mjc5NTA3ZWI5ZmY5MWFhMTRhYTIiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRRGVsMDEzdmxBMnhLT2hcblk5V2lYL3RNbm1LTkF2RVU4N3RLYjJqeVRieUZDeXdjTUlKR3dCUmVualhnRDl5VFQxcUplTTlUTHp5NjFTMlZcbmtnTWFQYm9GVEs1VVdiaFgvT1cveUhYc2pqS0JxZWhpQ3FZcC9PNDlESUNwdHBDOUl4Rm1ONERkaTJhS244VzdcbnkvUnAwVTJPSzJCa1FtUm5PbTRNU25LRVhYVS9iYVpUSStZMXlSQjN2OHFDOXhBN0ZoaXdGNHpvUFVKdU02S09cbm0xSXVhT3lCeGs2T1R0Q0k0SHNQNzltOGtOeFRTVDg0RUFHVkFLSW5NNFRVUDEwck1JZElJQ3NPNUdYWW51VWNcbkFlQzZmanZ0YWFVVEFueERDSmdWQ2lYSlhFM2p1TXZrNlYzeHlvNjBSVFVEb2ZyS2tSbzBLUWFWRWZ5N24vTk1cbmZ3YXNMV2dMQWdNQkFBRUNnZ0VBS1lUK2ViNEJsMTJ4aWZxbDBFNW9BU0F3RU02Q0twN1dDaW5pNFFPWURSY0tcbjZNMHhsOEhmYXRESEN0N2FqWTNKUFFoUVg5dFpVQjVRak93NThPeWZwTHByY0NkMko4OXdDWWg2V3FBaGtxY2ZcblJoNW5aVUNkTGIwRnlPSlplRFl3MmlpelBGL3l4aHZNVmQzUzN1UWdPOHNpaFVFUEdtUS9QOEtwUHNCeUROenRcbmk5UUM0TWNLYnVxbzNpd0ZuQUdTcDBvZXhnSEROQWpmaHlsY0YyeEdKcDMzN3dzcXN0MXNpNkJZNGVHdURSVXdcbm04RnE0ZG9RbFlobkx3TW1UQ1YwOEhoSVhHOGJxbkZWbkI3cnNTUkEwdjVIWkMyOERmSEhEak1DMUVtUmNFY0dcbjVlYUluUCtaN0NOcWRhbHdyRHo5QmVZL0ZpQlk3VzBiZXVKQXdzdlppUUtCZ1FEMFZMd3pyZnYvQ3loUWRuajZcbmZKTm8xWjVIVkhQZEJJMnpJZzZiQW1jbXFFa2FKUmNubVhwTSt0OVZnRWovWHNZc0xrbzdRZWtoamhYZ2VSSE9cbmg4K1FRN0tObUprd2ZnRWx0UXlxWVV5LzBZYTVzMU1ibDRYODlyaXdZTU5ZVFh5RVExQVdTUXZyNy9uZWtOK2ZcblhDa2VIRld5NzRMSVlnZWJIcXMvY0NReXlRS0JnUURwT01TWnFyT3NDVnUwSDQwNFJBZXU4Z0djUmN5elZIbUVcblZBVGN4RHZmcHQ3d0dYTHVEVlVmLzM4NVQvR0xIdG5Ndjc1ZWRaVnFMWm9sUGlLeFI2RGx6Z3g5NExBZnFFOHhcbjNxQ3lOTGJhRHR2TlBXRlMxWlhValJaUEFZa3FKMFJVQWx4Um14QzZkUVgvaDF0NWlwOGVUYTU0VEE1OGNpNEVcbkE5Mnc2T2Y2TXdLQmdBSTI2bVhGZysweDJyR3dBVFMwQUZvSTVhQmI0WmoxTzV1T0NYZmFNN2tqK1ZXbFZHcGxcbmQ3aE81Y3RPbUZySUx4K2pZOFRadWhVMXhuajhYKzd4U0M1VWpyKzl6RldtTHJoNnhaeWR1U1piN2M2dEUybkNcbm05SkpJaTluRVI0eHhaa2xTd3FJcXZUK2ZkTkltTjVHNVpDQ1RUeUw4ekdCd2ZQaitVVmY3TlFSQW9HQkFJakNcbkR4Y0U4RUxyWWVqbnI0blU2cVI5cU5BWVpnYXFmRzlLVFdlZmNuU2RoNUZIZXd0NHFmZ1BmRzBCSWVTd2ZJc0JcbnpRSGE5WGpEc09ZeDMyb1JWSm90RDBvcEhWNFM5ZzJLUExVREVFNGg5R1lQbmloU3NuOW5GRFBUOUxqUk9kSUJcbmFGMDZEcjhuckJMQkxyVEF3cm1rVjdDVytNK2tyTE1TQ1VlWjY1M2RBb0dBWVlVUlpDV2FPUkp0L3daL2syWXFcbnk0SVJ1Q0dSNGYzK2Rxd3VRaTd0NEhBS0IybHlvanVaUXByQUF0cVlUcktuZ2JMUmxoTVpHejdacy9RQk5MTS9cbjgyZHQyeXZHaERMZld1bVB2d25ZUFRvdFcrL01mdnB2SitjenI4QVRwVko3YTFiOGVJWXE5a2JiZE42YVJvOWZcbkp0Y3N4NXppOUVuKzhpTTJoY3FINm1zPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogInphcmluY2xpY2stYm90QHNhdnZ5LXBhcnNlci01MTUyMTktdDEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJjbGllbnRfaWQiOiAiMTE1MDg1MjI4Nzc5NDkxMjUxNDA2IiwKICAiYXV0aF91cmkiOiAiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tL28vb2F1dGgyL2F1dGgiLAogICJ0b2tlbl91cmkiOiAiaHR0cHM6Ly9vYXV0aDIuZ29vZ2xlYXBpcy5jb20vdG9rZW4iLAogICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwKICAiY2xpZW50X3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vcm9ib3QvdjEvbWV0YWRhdGEveDUwOS96YXJpbmNsaWNrLWJvdCU0MHNhdnZ5LXBhcnNlci01MTUyMTktdDEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJ1bml2ZXJzZV9kb21haW4iOiAiZ29vZ2xlYXBpcy5jb20iCn0K';

  // آیدی شیت خودت
  static const String _spreadsheetId = '1cPFwgLgUyS1GvQzlsaYEjm4OuH1C18FEO4N9PABNM70';
  static const String _sheetName = 'Sheet1';

  // تابع اتصال به شیت
  static Future<GSheets> _getGSheets() async {
    final jsonString = utf8.decode(base64.decode(_base64Key));
    final credentials = jsonDecode(jsonString);
    return GSheets(credentials);
  }

  // ثبت نام کاربر جدید
  static Future<void> initUser(String userId) async {
    try {
      final gsheets = await _getGSheets();
      final ss = await gsheets.spreadsheet(_spreadsheetId);
      final sheet = ss.worksheetByTitle(_sheetName);
      
      if (sheet == null) return;

      final rows = await sheet.values.allRows();
      bool userExists = false;
      for (var row in rows) {
        if (row.isNotEmpty && row[0] == userId) {
          userExists = true;
          break;
        }
      }

      if (!userExists) {
        // اگر کاربر جدید بود، با 0 سکه اضافه‌ش کن
        await sheet.values.append([userId, '0', DateTime.now().toIso8601String()]);
      }
    } catch (e) {
      print('Error initUser: $e');
    }
  }

  // آپدیت سکه‌های کاربر
  static Future<void> updateCoins(String userId, int coins) async {
    try {
      final gsheets = await _getGSheets();
      final ss = await gsheets.spreadsheet(_spreadsheetId);
      final sheet = ss.worksheetByTitle(_sheetName);
      
      if (sheet == null) return;

      final rows = await sheet.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i].isNotEmpty && rows[i][0] == userId) {
          // پیدا کردن سطر کاربر و آپدیتش
          await sheet.values.insertRow(i + 1, [userId, coins.toString(), DateTime.now().toIso8601String()]);
          break;
        }
      }
    } catch (e) {
      print('Error updateCoins: $e');
    }
  }
}