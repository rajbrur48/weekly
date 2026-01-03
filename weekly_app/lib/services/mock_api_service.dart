import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/report_model.dart';

class MockApiService {
  // Simulate fetching data for a specific branch and week
  static Future<ReportData> fetchReportData(int branchId, int weekId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock data that mirrors the PHP API response structure
    final mockJson = {
      "deposits": {
        "june_balance": 6977.88,
        "target_deposit": 9600.00,
        "achv_deposit": 7297.42,
        "achv_deposit_curr_week": 128.76,
        "last_year_achv": 7332.28,
        "balance_deposit": 701.31,
        "target_new_ac": 745,
        "achv_new_ac": 415,
        "target_schemes": 539,
        "achv_schemes": 112
      },
      "recovery": {
        "wcl_1_target": 135.86,
        "wcl_1_achv": 130.73,
        "wcl_2_target": 319.05,
        "wcl_2_achv": 230.61,
        "ncl_target": 232.17,
        "ncl_achv": 4.29,
        "cl_target": 397.00,
        "cl_achv": 218.27
      },
      "loan_sectors": [
        {"sector_code": "crop", "target": 80.00, "achv": 69.56},
        {"sector_code": "fishery", "target": 107.00, "achv": 87.18},
        {"sector_code": "sme", "target": 225.00, "achv": 105.72}
      ],
      "loan_general": {
        "borrowers_target": 1500,
        "borrowers_curr": 688
      }
    };

    if (kDebugMode) {
      print("Mock API Response: $mockJson");
    }

    return ReportData.fromJson(mockJson);
  }
}
