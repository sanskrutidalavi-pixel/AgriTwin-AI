import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';

/// Transactions, Detailed Bill Invoice & Grievance Portal
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _buyerRating = 5;
  final TextEditingController _grievanceController = TextEditingController();
  String _selectedGrievanceType = 'Payment Related Issue';

  Future<void> _generateAndDownloadPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // HEADER
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('AGRITWIN AI PLATFORM', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                      pw.Text('Pune Region Digital Twin System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: pw.BoxDecoration(color: PdfColors.green100, borderRadius: pw.BorderRadius.circular(6)),
                    child: pw.Text('TRANSACTION INVOICE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1.5, color: PdfColors.grey400),
              pw.SizedBox(height: 12),

              // TRANSACTION METADATA
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Transaction ID: TRX-PUNE-8812', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Date: 06-Sep-2026', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Status: PAYMENT COMPLETED', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                      pw.Text('Escrow Funds Settled via UPI', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // PARTIES INVOLVED
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('FARMER / SELLER:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                        pw.Text('Ramesh Patil', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Haveli, Pune, Maharashtra', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BUYER:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                        pw.Text('Shree Gurukrupa Restaurant', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Deccan Gymkhana, Pune', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('TRANSPORT AGENCY:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                        pw.Text('Sahyadri Logistics Fleet', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Eicher Pro 2.5T (MH-12-PQ-4821)', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // COST BREAKDOWN TABLE
              pw.Text('PRODUCE & COST BREAKDOWN', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
              pw.SizedBox(height: 6),

              pw.Table.fromTextArray(
                headers: ['Item / Produce Description', 'Quantity & Unit', 'Quality Grade', 'Rate', 'Total Amount'],
                data: [
                  ['Tomato (Abhinav Hybrid)', '600 kg (6 Quintals)', 'Grade A (Verified 📸)', '₹30.0 / kg', '₹18,000'],
                  ['Transportation Fee (Haveli ➔ Deccan)', '14 km Direct Trip', 'FPO Collective Fleet', '₹85 / km', '₹1,200'],
                  ['Cold Storage / Handling', 'Sahyadri Hadapsar', 'Temp Controlled', 'Subsidized', '₹0'],
                  ['Escrow Platform Security Fee', 'AgriTwin AI Protocol', 'Verified Escrow', 'Waived', '₹0'],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
                rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),

              pw.SizedBox(height: 16),

              // TOTAL AMOUNT SUMMARY
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 220,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green50,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: PdfColors.green800),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Produce Subtotal:', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('₹18,000', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Transport Fee:', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('₹1,200', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Divider(thickness: 1, color: PdfColors.green800),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total Amount Paid:', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
                            pw.Text('₹18,000', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // FOOTER
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Generated from the platform transaction system.', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('AgriTwin AI Pune Region System • Page 1 of 1', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final filename = 'Transaction_Invoice_TRX-PUNE-8812.pdf';

    await Printing.sharePdf(bytes: bytes, filename: filename);

    if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.tr('Invoice downloaded successfully.')),
          backgroundColor: AppColors.positive,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showInvoiceModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.tr('Detailed Bill / Invoice'),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.tr('Invoice No:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const Text('TRX-PUNE-8812', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.tr('Date:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const Text('06-Sep-2026', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.tr('Status:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text(AppLocalizations.tr('PAYMENT COMPLETED'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.positive)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.tr('Farmer / Seller:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const Expanded(
                      child: Text('Ramesh Patil (Haveli, Pune)', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.tr('Buyer:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const Expanded(
                      child: Text('Shree Gurukrupa Restaurant', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.tr('Transporter:'), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const Expanded(
                      child: Text('Sahyadri Logistics Fleet', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                _billItem(AppLocalizations.tr('Tomato (Grade A)'), '600 kg @ ₹30/kg', '₹18,000'),
                _billItem(AppLocalizations.tr('Transport Fee (FPO Fleet)'), AppLocalizations.tr('Distance 14 km'), '₹1,200'),
                _billItem(AppLocalizations.tr('Cold Storage / Handling'), 'Sahyadri Hadapsar', AppLocalizations.tr('Subsidized')),
                _billItem(AppLocalizations.tr('Escrow Protection Fee'), AppLocalizations.tr('Waived by FPO'), '₹0'),

                const Divider(),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.tr('Total Amount Paid:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const Text('₹18,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.positive)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _generateAndDownloadPdf(context);
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                label: Text(AppLocalizations.tr('Download PDF Invoice 📄'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _billItem(String title, String subtitle, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  void _showGrievanceModal(BuildContext context) {
    final role = MockData.activeUserRole;
    final isBuyer = role == 'Buyer';
    final isTransporter = role == 'Transportation Agency';
    final grievanceTypes = isBuyer
        ? [
            'Payment Related Issue',
            'Quantity Mismatch',
            'Quality Dispute',
            'Delivery Transport Delay',
          ]
        : ['Payment Related Issue'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.report_problem_rounded, color: AppColors.urgent, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.tr('Raise Issue or Grievance'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.tr('Select Issue Type:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: grievanceTypes.contains(_selectedGrievanceType) ? _selectedGrievanceType : grievanceTypes.first,
                items: grievanceTypes.map((t) => DropdownMenuItem(value: t, child: Text(AppLocalizations.tr(t), style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => setState(() => _selectedGrievanceType = val!),
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 12),
              Text(AppLocalizations.tr('Describe Grievance Details:'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _grievanceController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: isTransporter
                      ? AppLocalizations.tr('Freight payment clearance delayed by buyer or agency settlement.')
                      : AppLocalizations.tr('Issue with payment, quantity discrepancy, quality grade dispute, or transport delay.'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.tr('Grievance Submitted Successfully! AgriTwin Escrow Officer notified.')),
                    backgroundColor: AppColors.urgent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.urgent),
              child: Text(AppLocalizations.tr('Submit Grievance'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = MockData.activeUserRole;
    final isTransporter = role == 'Transportation Agency';
    final txns = MockData.transactionList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.tr('Transactions')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Switch Role / Back to Login',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TRANSACTIONS LIST
              Text(
                AppLocalizations.tr(isTransporter ? 'Completed & Active Trip Freight Costings' : 'Recent Completed & Active Transactions'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              ...txns.map((t) {
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.transactionId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.positiveLight, borderRadius: BorderRadius.circular(8)),
                              child: Text(AppLocalizations.tr('COMPLETED'), style: const TextStyle(color: AppColors.positive, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // IF TRANSPORTER ROLE -> DISPLAY TRANSPORTER FREIGHT COSTING ONLY
                        if (isTransporter) ...[
                          const Text('Route: Haveli Farm ➔ Deccan Gymkhana (14 km)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const Text('Assigned Vehicle: Eicher Pro 2.5T (MH-12-PQ-4821)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Freight Costing Rate: ₹85 / km', style: TextStyle(fontSize: 12)),
                              Flexible(
                                child: Text('Freight Earned: ₹1,200', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.positive), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ],

                        // IF FARMER OR BUYER -> DISPLAY FULL TRANSACTION
                        if (!isTransporter) ...[
                          Text(AppLocalizations.tr(t.produceCrop), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('${AppLocalizations.tr('Buyer:')} ${t.buyerName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.tr('6 Quintals (600 kg)'), style: const TextStyle(fontSize: 13)),
                              const Text('Total: ₹18,000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.positive)),
                            ],
                          ),

                          // PAYMENT COMPLETED STATUS BANNER
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: AppColors.positiveLight, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.positive, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.tr('✅ Payment Status: PAYMENT COMPLETED & RECEIVED IN BANK'),
                                    style: const TextStyle(color: AppColors.positive, fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 8),

                        // MUTUAL 5-STAR RATING SYSTEM
                        Row(
                          children: [
                            Text(AppLocalizations.tr('Rate Deal / Trip:'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _buyerRating = starIndex + 1);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Rated ${starIndex + 1} Stars! Rating saved.')),
                                    );
                                  },
                                  child: Icon(
                                    starIndex < _buyerRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: Colors.amber,
                                    size: 22,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ACTION BUTTONS: View Details Bill & Payment Grievance
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showInvoiceModal(context),
                                icon: const Icon(Icons.receipt_rounded, color: Colors.white, size: 16),
                                label: Text(AppLocalizations.tr('View Details Bill'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showGrievanceModal(context),
                                icon: const Icon(Icons.report_problem_outlined, color: AppColors.urgent, size: 16),
                                label: Text(AppLocalizations.tr('Raise Issue or Grievance'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.urgent, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.urgent)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
