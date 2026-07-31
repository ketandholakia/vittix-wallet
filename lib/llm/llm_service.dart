import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediapipe_genai/mediapipe_genai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart'; // Reusing this generic candidate format

final llmServiceProvider = Provider<LlmService>((ref) {
  return LlmService();
});

class LlmService {
  LlmInferenceEngine? _llmInference;
  bool _isInitializing = false;

  Future<void> _initIfNeeded() async {
    if (_llmInference != null) return;
    if (_isInitializing) {
      // Very simple lock mechanism for basic usage
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _isInitializing = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final modelPath = prefs.getString('llm_model_path');

      if (modelPath == null || modelPath.isEmpty) {
        throw Exception("No LLM model path selected in Settings.");
      }
      
      final cacheDir = await getTemporaryDirectory();

      final options = LlmInferenceOptions.cpu(
        modelPath: modelPath,
        cacheDir: cacheDir.path,
        maxTokens: 512,
        temperature: 0.1, // Keep it low for JSON extraction tasks
        topK: 40,
        randomSeed: 42,
      );

      _llmInference = LlmInferenceEngine(options);
    } finally {
      _isInitializing = false;
    }
  }

  Future<PdfTransactionCandidate> parseSms(String smsBody) async {
    await _initIfNeeded();

    if (_llmInference == null) {
      throw Exception("LLM engine could not be initialized.");
    }

    final prompt = '''
You are a highly accurate financial SMS parser. Extract the following from the SMS text below.
If it's an expense, amount should be positive. If income, amount should be positive.
Return ONLY valid JSON with keys: "merchant" (string), "amount" (number), "type" (either "expense" or "income").
No other text, markdown formatting, or explanations.

SMS:
"$smsBody"

JSON:
''';

    final stream = _llmInference!.generateResponse(prompt);
    final response = await stream.join('');

    return _parseJsonResponse(response, smsBody);
  }

  PdfTransactionCandidate _parseJsonResponse(String response, String rawBody) {
    try {
      final cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();
      final map = jsonDecode(cleaned) as Map<String, dynamic>;

      final merchant = map['merchant']?.toString() ?? 'Unknown';
      
      final amountRaw = map['amount'];
      double amount = 0.0;
      if (amountRaw is num) {
        amount = amountRaw.toDouble();
      } else if (amountRaw is String) {
        amount = double.tryParse(amountRaw.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      }

      final typeStr = map['type']?.toString().toLowerCase();
      final type = typeStr == 'income' ? domain.TransactionType.income : domain.TransactionType.expense;

      return PdfTransactionCandidate(
        merchant: merchant,
        amount: amount,
        type: type,
        date: DateTime.now(),
        sourceFile: 'LLM Parser',
        rawBlock: rawBody,
        confidence: 0.95,
      );
    } catch (e) {
      throw Exception("Failed to parse LLM response: $e\nRaw Response: $response");
    }
  }

  Future<PdfTransactionCandidate> parseReceipt(String receiptText) async {
    await _initIfNeeded();

    if (_llmInference == null) {
      throw Exception("LLM engine could not be initialized.");
    }

    final prompt = '''
You are a highly accurate receipt parser. Extract the following from the raw receipt text below.
If it's an expense, amount should be positive. If income, amount should be positive.
Return ONLY valid JSON with keys: "merchant" (string), "amount" (number), "type" (either "expense" or "income").
No other text, markdown formatting, or explanations.

Receipt Text:
"$receiptText"

JSON:
''';

    final stream = _llmInference!.generateResponse(prompt);
    final response = await stream.join('');

    return _parseJsonResponse(response, receiptText);
  }

  void dispose() {
    _llmInference?.dispose();
  }
}
