import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ExcelGenerator {
  static Future<void> generateExcel(BuildContext context, List<dynamic> reports) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Header Row
    sheetObject.appendRow([
      TextCellValue('Branch Name'),
      TextCellValue('Deposit Target'),
      TextCellValue('Deposit Achv'),
      TextCellValue('Deposit %'),
      TextCellValue('Loan Target'),
      TextCellValue('Loan Achv'),
      TextCellValue('Recovery Target'),
      TextCellValue('Recovery Achv'),
      TextCellValue('WCL-1 Achv'),
      TextCellValue('CL Achv'),
      TextCellValue('Outstanding Balance')
    ]);

    // Data Rows
    for (var row in reports) {
      double depTarget = double.tryParse(row['target_deposit'] ?? '') ?? 0.0;
      double depAchv = double.tryParse(row['achv_deposit'] ?? '') ?? 0.0;
      double depPct = depTarget > 0 ? (depAchv / depTarget) * 100 : 0.0;

      // Logic to sum loan sectors would go here if we had the nested data in this view
      // For now using 0.0 or checking if 'loan_sectors' is available in the row map
      double loanTarget = 0.0;
      double loanAchv = 0.0;
      if (row['loan_sectors'] != null && row['loan_sectors'] is Map) {
         (row['loan_sectors'] as Map).forEach((k, v) {
            loanTarget += double.tryParse(v['target']?.toString() ?? '0') ?? 0;
            loanAchv += double.tryParse(v['achv']?.toString() ?? '0') ?? 0;
         });
      }

      sheetObject.appendRow([
        TextCellValue(row['branch_name'] ?? ''),
        DoubleCellValue(depTarget),
        DoubleCellValue(depAchv),
        DoubleCellValue(double.parse(depPct.toStringAsFixed(2))),
        DoubleCellValue(loanTarget),
        DoubleCellValue(loanAchv),
        DoubleCellValue(double.tryParse(row['outstanding_target'] ?? '') ?? 0.0),
        DoubleCellValue(double.tryParse(row['outstanding_balance'] ?? '') ?? 0.0), // Simplified
        DoubleCellValue(double.tryParse(row['wcl_1_achv'] ?? '') ?? 0.0),
        DoubleCellValue(double.tryParse(row['cl_achv'] ?? '') ?? 0.0),
        DoubleCellValue(double.tryParse(row['outstanding_balance'] ?? '') ?? 0.0),
      ]);
    }

    // Save File
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/WeeklyReport.xlsx');
    final fileBytes = excel.save();

    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel Saved: ${file.path}')),
        );
      }
    }
  }
}
