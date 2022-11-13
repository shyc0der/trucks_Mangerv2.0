import 'package:pdf_reports_generator/pdf_reports_generator.dart';

abstract class ReportGeneratorModule {
  Future<Document>? generatePdf({PdfPageFormat? pageFormat});
}