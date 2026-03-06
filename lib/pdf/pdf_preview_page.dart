import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../logic/score_controller.dart';
import '../pdf/auswertung_pdf.dart';

class PdfPreviewPage extends StatelessWidget {
  final ScoreController controller;
  final String team1;
  final String team2;

  const PdfPreviewPage({
    super.key,
    required this.controller,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text("PDF Vorschau"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PdfPreview(
        build: (format) => AuswertungPdf(
          controller: controller,
          team1: team1,
          team2: team2,
        ).build(format),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: true,
        canChangePageFormat: true,
        initialPageFormat: PdfPageFormat.a4.landscape,
      ),
    );
  }
}
