import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/services/receipt_ai_service.dart';

class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen> {
  final _service = ReceiptAiService();
  bool _loading = false;

  Future<void> _capture(ImageSource source) async {
    setState(() => _loading = true);
    final parsed = await _service.pickAndParseReceipt(source);
    if (!mounted) return;

    setState(() => _loading = false);
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not parse receipt. Please verify backend keys or fill manually.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Receipt')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Icon(
              Icons.receipt_long_rounded,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 24),
            const Text(
              'AI Receipt Scanner',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Snap a photo of your receipt or upload an image from your gallery to auto-fill expense details instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const Spacer(),
            if (_loading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 16),
                    Text(
                      'AI is parsing your receipt...',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: () => _capture(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Take a Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () => _capture(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Upload from Gallery'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            const Spacer(),
            TextButton(
              onPressed: _loading ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Skip & Enter Manually',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
