import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/receipt_ai_service.dart';
import '../../l10n/app_localizations.dart';

class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen> {
  final _service = ReceiptAiService();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _capture(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image == null) return; // User cancelled the camera/gallery, do nothing!

    setState(() => _loading = true);
    try {
      final parsed = await _service.parseReceiptFile(image);
      if (!mounted) return;
      setState(() => _loading = false);
      context.pop(parsed);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = AppLocalizations.of(context)!.couldNotParseReceipt;
      });

      if (e is DioException) {
        final serverMessage = e.response?.data?['message'];
        if (serverMessage != null && serverMessage.isNotEmpty) {
          _errorMessage = serverMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 12),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.dismiss,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanReceiptTitle)),
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
            Text(
              l10n.aiReceiptScanner,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.receiptScannerDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const Spacer(),
            if (_errorMessage != null && !_loading)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => setState(() => _errorMessage = null),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: OutlinedButton(
                        onPressed: _loading
                            ? null
                            : () => _capture(ImageSource.camera),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                        child: Text(l10n.retryScan),
                      ),
                    ),
                  ],
                ),
              ),
            if (_loading)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.teal),
                    const SizedBox(height: 16),
                    Text(
                      l10n.aiParsingReceipt,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: _loading ? null : () => _capture(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded),
                label: Text(l10n.takePhoto),
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
                onPressed:
                    _loading ? null : () => _capture(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded),
                label: Text(l10n.uploadFromGallery),
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
                l10n.skipEnterManually,
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
