import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use emulator address for local testing:
  // iOS emulator: localhost or 127.0.0.1
  // Android emulator: 10.0.2.2
  static const String base = "http://192.168.100.30:3000";

  // Sync endpoint
  // Expects { localMessages: [...], lastSyncTime: "ISO" }
  // Returns serverMessages array
  static Future<Map<String, dynamic>?> sync(
    List localMessages,
    String lastSyncTime,
  ) async {
    final url = Uri.parse("$base/sync");
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "localMessages": localMessages,
          "lastSyncTime": lastSyncTime,
        }),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      // network error
      return null;
    }
  }

  // convenience
  static Future<List?> fetchAll() async {
    try {
      final res = await http.get(Uri.parse("$base/messages"));
      if (res.statusCode == 200) return jsonDecode(res.body) as List;
    } catch (_) {}
    return null;
  }
}
