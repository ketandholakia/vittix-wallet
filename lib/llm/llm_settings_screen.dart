import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LlmSettingsScreen extends StatefulWidget {
  const LlmSettingsScreen({super.key});

  @override
  State<LlmSettingsScreen> createState() => _LlmSettingsScreenState();
}

class _LlmSettingsScreenState extends State<LlmSettingsScreen> {
  String? _modelPath;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadModelPath();
  }

  Future<void> _loadModelPath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modelPath = prefs.getString('llm_model_path');
    });
  }

  Future<void> _pickModel() async {
    setState(() => _loading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['bin'],
      );
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('llm_model_path', path);
        setState(() {
          _modelPath = path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Model file selected successfully.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick model: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _clearModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('llm_model_path');
    setState(() {
      _modelPath = null;
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings (MediaPipe)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.smart_toy_outlined, size: 64, color: Colors.blueGrey),
          const SizedBox(height: 16),
          Text(
            'On-Device LLM Inference',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Use MediaPipe GenAI to run models (like Qwen or Gemma) entirely locally on your device for absolute privacy. Zero data leaves your phone.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Model Path', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _modelPath ?? 'No model selected',
                    style: TextStyle(
                      color: _modelPath == null ? Colors.red : Colors.green,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_modelPath != null)
                    FutureBuilder<bool>(
                      future: File(_modelPath!).exists(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasData && snapshot.data == true) {
                          return const Text('File exists on device.', style: TextStyle(color: Colors.green));
                        } else {
                          return const Text('File not found! Please re-select.', style: TextStyle(color: Colors.red));
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _pickModel,
            icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.folder_open),
            label: const Text('Select .bin Model File'),
          ),
          if (_modelPath != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loading ? null : _clearModel,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Model'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ] else ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Need a model? Download a lightweight MediaPipe GenAI compatible model (like Gemma 2B or Qwen 1.5B in .bin format) to your device, then select it above.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _launchUrl('https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/android#models'),
              icon: const Icon(Icons.download),
              label: const Text('Download Models from Google AI Edge'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _launchUrl('https://www.kaggle.com/models/google/gemma/frameworks/mediaPipe'),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Get Gemma on Kaggle'),
            ),
          ],
        ],
      ),
    );
  }
}
