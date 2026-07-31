import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfTextExtractorUtil {
  /// Extracts text from a PDF file
  static Future<String> extractText(File file) async {
    final bytes = await file.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);
    
    final StringBuffer text = StringBuffer();
    for (int i = 0; i < document.pages.count; i++) {
      text.writeln(extractor.extractText(startPageIndex: i, endPageIndex: i));
    }
    
    document.dispose();
    return text.toString();
  }
}
