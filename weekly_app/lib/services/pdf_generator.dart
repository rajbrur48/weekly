import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateReport(List<dynamic> reports) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Center(
                  child: pw.Text('Bangladesh Krishi Bank - Weekly Report', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header Row
                  pw.TableRow(
                    children: [
                      _buildCell('Branch Name', isHeader: true),
                      _buildCell('Deposit Target', isHeader: true),
                      _buildCell('Deposit Achv', isHeader: true),
                      _buildCell('Loan Target', isHeader: true),
                      _buildCell('Loan Achv', isHeader: true),
                      _buildCell('Recovery Target', isHeader: true),
                      _buildCell('Recovery Achv', isHeader: true),
                    ],
                  ),
                  // Data Rows
                  ...reports.map((row) {
                     return pw.TableRow(
                       children: [
                         _buildCell(row['branch_name'] ?? ''),
                         _buildCell(row['target_deposit'] ?? '-'),
                         _buildCell(row['achv_deposit'] ?? '-'),
                         // Placeholders for aggregated loan data
                         _buildCell('-'),
                         _buildCell('-'),
                         _buildCell(row['outstanding_target'] ?? '-'),
                         _buildCell(row['outstanding_balance'] ?? '-'),
                       ]
                     );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: 8, // Smaller font for landscape table
        ),
      ),
    );
  }
}
