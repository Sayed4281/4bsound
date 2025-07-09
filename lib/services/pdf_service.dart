import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/app_state.dart';

class PDFService {
  static Future<void> generateQuotationPDF(Quotation quotation) async {
    final pdf = pw.Document();

    // Load the company logo
    pw.ImageProvider? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/4b SOUNDS.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (e) {
      // Logo loading failed, will use text-only header
      logoImage = null;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#2196F3'),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  children: [
                    // Logo section
                    if (logoImage != null) ...[
                      pw.Container(
                        width: 60,
                        height: 60,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Image(logoImage),
                        ),
                      ),
                      pw.SizedBox(width: 16),
                    ],
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '4B SOUND',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'MUSIC BAND',
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'MELATTUR, PALAKKAD DISTRICT, KERALA',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            'Phone: +91 70259 75798',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Quotation title
              pw.Center(
                child: pw.Text(
                  'QUOTATION',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#2196F3'),
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // Client and event details
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'CLIENT DETAILS',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text('Name: ${quotation.clientName}'),
                        pw.Text('Contact: ${quotation.clientContact}'),
                        if (quotation.clientAddress.isNotEmpty)
                          pw.Text('Address: ${quotation.clientAddress}'),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'EVENT DETAILS',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text('Event: ${quotation.eventType}'),
                        pw.Text('Date: ${quotation.eventDate.day}/${quotation.eventDate.month}/${quotation.eventDate.year}'),
                        pw.Text('Venue: ${quotation.venue}'),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Items table
              pw.Text(
                'ITEMS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#E3F2FD'),
                    ),
                    children: [
                      _tableCell('Description', isHeader: true),
                      _tableCell('Qty', isHeader: true),
                      _tableCell('Unit Price', isHeader: true),
                      _tableCell('Total', isHeader: true),
                    ],
                  ),
                  // Items
                  ...quotation.items.map((item) => pw.TableRow(
                    children: [
                      _tableCell(item.description),
                      _tableCell(item.quantity.toString()),
                      _tableCell('₹${item.unitPrice.toStringAsFixed(0)}'),
                      _tableCell('₹${item.total.toStringAsFixed(0)}'),
                    ],
                  )).toList(),
                ],
              ),

              pw.SizedBox(height: 20),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Text('Subtotal:'),
                          ),
                          pw.SizedBox(
                            width: 80,
                            child: pw.Text(
                              '₹${quotation.subtotal.toStringAsFixed(0)}',
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Text('GST (18%):'),
                          ),
                          pw.SizedBox(
                            width: 80,
                            child: pw.Text(
                              '₹${quotation.tax.toStringAsFixed(0)}',
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        height: 1,
                        width: 180,
                        color: PdfColors.grey,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Text(
                              'Total:',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          pw.SizedBox(
                            width: 80,
                            child: pw.Text(
                              '₹${quotation.total.toStringAsFixed(0)}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                                color: PdfColor.fromHex('#2196F3'),
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Notes
              if (quotation.notes.isNotEmpty) ...[
                pw.Text(
                  'NOTES',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(quotation.notes),
                pw.SizedBox(height: 20),
              ],

              // Footer
              pw.Spacer(),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#E3F2FD'),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'Thank you for choosing 4B SOUND!',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#2196F3'),
                    ),
                  ),
                ),
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

  static pw.Widget _tableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 12 : 10,
        ),
      ),
    );
  }
}
