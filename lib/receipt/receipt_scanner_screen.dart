// BROKEN DEPENDENCY: Experimental
/*

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:expense_tracker/llm/llm_service.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen.dart';
import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart';

class ReceiptScannerScreen extends ConsumerStatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  ConsumerState<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  String _statusMessage = '';

  Future<void> _scanReceipt(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _isProcessing = true;
        _statusMessage = 'Extracting text...';
      });

      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      if (recognizedText.text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No text found in the image.')),
        );
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      setState(() {
        _statusMessage = 'Analyzing with LLM...';
      });

      final llmService = ref.read(llmServiceProvider);
      final PdfTransactionCandidate candidate = await llmService.parseReceipt(recognizedText.text);

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      // Navigate to AddTransactionScreen with the parsed data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddTransactionScreen(
            initialAmount: candidate.amount,
            initialMerchant: candidate.merchant,
            initialType: candidate.type,
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing receipt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipt'),
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(_statusMessage),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 100, color: Colors.grey),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _scanReceipt(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _scanReceipt(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                  ),
                ],
              ),
      ),
    );
  }
}

*/