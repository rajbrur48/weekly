import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report_model.dart';

class ApiService {
  // Replace with your actual machine IP if running on emulator (e.g., 10.0.2.2 for Android)
  static const String baseUrl = 'http://10.0.2.2/weekly_backend';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getMetaData() async {
    final response = await http.get(Uri.parse('$baseUrl/get_metadata.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load metadata');
  }

  static Future<ReportData> getReportData(int branchId, int weekId) async {
    final url = '$baseUrl/get_report_data.php?branch_id=$branchId&week_id=$weekId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
         // Handle case where data is null (new entry)
         if (json['data'] == null || (json['data']['deposits'] == null && json['data']['recovery'] == null)) {
            return ReportData(
              deposits: DepositData(),
              recovery: RecoveryData(),
              loanSectors: [],
              loanGeneral: LoanGeneralData()
            );
         }
         return ReportData.fromJson(json['data']);
      }
    }
    throw Exception('Failed to load report data');
  }

  static Future<List<dynamic>> generateFullReport(int weekId) async {
     final url = '$baseUrl/generate_full_report.php?week_id=$weekId';
     final response = await http.get(Uri.parse(url));

     if (response.statusCode == 200) {
       final json = jsonDecode(response.body);
       if (json['status'] == 'success') {
         return json['data'];
       }
     }
     throw Exception('Failed to generate report');
  }

  static Future<void> submitReport(int branchId, int weekId, ReportData data) async {
    final body = {
      'branch_id': branchId,
      'week_id': weekId,
      'data': data.toJson()
    };

    final response = await http.post(
      Uri.parse('$baseUrl/submit_report.php'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit report: ${response.body}');
    }

    final json = jsonDecode(response.body);
    if (json['status'] != 'success') {
      throw Exception(json['message']);
    }
  }
}
