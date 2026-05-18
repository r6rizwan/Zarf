import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import 'api_service.dart';

class ParsedReceipt {
  final String? merchant;
  final double? amount;
  final String? currency;
  final DateTime? date;

  const ParsedReceipt({
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.date,
  });

  factory ParsedReceipt.fromJson(Map<String, dynamic> json) => ParsedReceipt(
        merchant: json['merchant']?.toString(),
        amount: (json['amount'] as num?)?.toDouble(),
        currency: json['currency']?.toString(),
        date: json['date'] != null
            ? DateTime.tryParse(json['date'].toString())
            : null,
      );
}

class ReceiptAiService {
  final _api = ApiService.instance;
  final _picker = ImagePicker();

  Future<ParsedReceipt?> parseReceiptFile(XFile image) async {
    try {
      final fileName = image.name.isNotEmpty ? image.name : 'receipt.jpg';
      final ext = fileName.split('.').last.toLowerCase();
      final subtype = ext == 'png' ? 'png' : (ext == 'webp' ? 'webp' : 'jpeg');

      final formData = FormData.fromMap({
        'receipt': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType('image', subtype),
        ),
      });

      final res =
          await _api.dio.post('/expenses/parse-receipt', data: formData);
      if (res.data['success'] != true) return null;
      return ParsedReceipt.fromJson(
          Map<String, dynamic>.from(res.data['data']));
    } catch (e) {
      print('Receipt Parsing Error: $e');
      return null;
    }
  }

  Future<ParsedReceipt?> pickAndParseReceipt(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image == null) return null;
    return parseReceiptFile(image);
  }
}
