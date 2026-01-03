import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../services/api_service.dart';
import '../services/pdf_generator.dart';
import '../services/excel_generator.dart';

class ReportViewScreen extends StatefulWidget {
  const ReportViewScreen({super.key});

  @override
  State<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  int? weekId;
  List<dynamic> _reports = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (weekId == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        weekId = args['week_id'];
        _loadReport();
      }
    }
  }

  void _loadReport() async {
    if (weekId == null) return;
    try {
      final data = await ApiService.generateFullReport(weekId!);
      setState(() {
        _reports = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  // Helper to safely parse double
  double _d(dynamic val) => double.tryParse(val?.toString() ?? '0') ?? 0.0;

  // Helper to calculate Percentage
  String _pct(double target, double achv) {
    if (target == 0) return '0%';
    return '${((achv / target) * 100).toStringAsFixed(0)}%';
  }

  // Calculate Loan Totals from Sector Map
  Map<String, double> _calculateLoanTotals(Map<dynamic, dynamic>? sectors) {
    double target = 0;
    double achv = 0;
    if (sectors != null) {
      sectors.forEach((k, v) {
        target += _d(v['target']);
        achv += _d(v['achv']);
      });
    }
    return {'target': target, 'achv': achv};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সাপ্তাহিক রিপোর্ট'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'PDF Export',
            onPressed: () {
               if (_reports.isNotEmpty) {
                 PdfGenerator.generateReport(_reports);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating PDF...')));
               }
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_view),
            tooltip: 'Excel Export',
            onPressed: () {
               if (_reports.isNotEmpty) {
                 ExcelGenerator.generateExcel(context, _reports);
               }
            },
          )
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: const Column(
                children: [
                  Text(
                    'বাংলাদেশ কৃষি ব্যাংক',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text('মুখ্য আঞ্চলিক কার্যালয়, ফেনী'),
                ],
              ),
            ),

            // Sticky Table
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 2500, // Wide scrolling
                  fixedLeftColumns: 1,
                  border: TableBorder.all(color: Colors.grey),
                  headingRowColor: MaterialStateProperty.all(Colors.green[100]),
                  columns: const [
                    DataColumn2(label: Text('শাখার নাম'), fixedWidth: 100),
                    // Deposit
                    DataColumn2(label: Text('আমানত লক্ষ্য'), numeric: true),
                    DataColumn2(label: Text('আমানত অর্জন'), numeric: true),
                    DataColumn2(label: Text('হার %'), numeric: true),
                    // Loan Aggregated
                    DataColumn2(label: Text('মোট ঋণ লক্ষ্য'), numeric: true),
                    DataColumn2(label: Text('মোট ঋণ অর্জন'), numeric: true),
                    DataColumn2(label: Text('হার %'), numeric: true),
                    // Recovery Breakdown
                    DataColumn2(label: Text('WCL-1 অর্জন'), numeric: true),
                    DataColumn2(label: Text('WCL-2 অর্জন'), numeric: true),
                    DataColumn2(label: Text('WCL-3 অর্জন'), numeric: true),
                    DataColumn2(label: Text('WCL-4 অর্জন'), numeric: true),
                    DataColumn2(label: Text('NCL অর্জন'), numeric: true),
                    DataColumn2(label: Text('CL অর্জন'), numeric: true),
                    DataColumn2(label: Text('রিসিডিউল অর্জন'), numeric: true),
                    DataColumn2(label: Text('অবলোপন স্থিতি'), numeric: true),
                    DataColumn2(label: Text('রেমিট্যান্স অর্জন'), numeric: true),
                    DataColumn2(label: Text('অনাদায়ী স্থিতি'), numeric: true),
                  ],
                  rows: [
                    ..._reports.map((row) {
                       double depTarget = _d(row['target_deposit']);
                       double depAchv = _d(row['achv_deposit']);

                       var loanTotals = _calculateLoanTotals(row['loan_sectors']);
                       double loanTarget = loanTotals['target']!;
                       double loanAchv = loanTotals['achv']!;

                       return DataRow(cells: [
                         DataCell(Text(row['branch_name'] ?? '')),

                         DataCell(Text(depTarget.toStringAsFixed(2))),
                         DataCell(Text(depAchv.toStringAsFixed(2))),
                         DataCell(Text(_pct(depTarget, depAchv))),

                         DataCell(Text(loanTarget.toStringAsFixed(2))),
                         DataCell(Text(loanAchv.toStringAsFixed(2))),
                         DataCell(Text(_pct(loanTarget, loanAchv))),

                         DataCell(Text(_d(row['wcl_1_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['wcl_2_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['wcl_3_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['wcl_4_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['ncl_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['cl_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['reschedule_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['writeoff_balance']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['remittance_achv']).toStringAsFixed(2))),
                         DataCell(Text(_d(row['outstanding_balance']).toStringAsFixed(2))),
                       ]);
                    }),
                    // Total Row
                    _buildTotalRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  DataRow _buildTotalRow() {
    double totalDepTarget = 0;
    double totalDepAchv = 0;
    double totalLoanTarget = 0;
    double totalLoanAchv = 0;
    // ... sums for others

    for (var r in _reports) {
      totalDepTarget += _d(r['target_deposit']);
      totalDepAchv += _d(r['achv_deposit']);

      var lt = _calculateLoanTotals(r['loan_sectors']);
      totalLoanTarget += lt['target']!;
      totalLoanAchv += lt['achv']!;
    }

    return DataRow(
      color: MaterialStateProperty.all(Colors.grey[300]),
      cells: [
        const DataCell(Text('মোট', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(totalDepTarget.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(totalDepAchv.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(_pct(totalDepTarget, totalDepAchv), style: const TextStyle(fontWeight: FontWeight.bold))),

        DataCell(Text(totalLoanTarget.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(totalLoanAchv.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(_pct(totalLoanTarget, totalLoanAchv), style: const TextStyle(fontWeight: FontWeight.bold))),

        // Placeholders for other totals for brevity in this snippet, but logic is same
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
      ]
    );
  }
}
