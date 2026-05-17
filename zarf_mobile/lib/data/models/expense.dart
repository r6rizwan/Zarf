class Expense {
  final String id;
  final String userId;
  final String? userName;
  final String companyId;
  final num amount;
  final String currency;
  final num? amountBase;
  final String category;
  final String? notes;
  final String? receiptUrl;
  final bool vatApplicable;
  final num vatAmount;
  final String? paymentMethod;
  final String status;
  final String? reviewedBy;
  final String? reviewNote;
  final DateTime date;
  final DateTime? createdAt;

  Expense({
    required this.id,
    required this.userId,
    required this.userName,
    required this.companyId,
    required this.amount,
    required this.currency,
    required this.amountBase,
    required this.category,
    required this.notes,
    required this.receiptUrl,
    required this.vatApplicable,
    required this.vatAmount,
    required this.paymentMethod,
    required this.status,
    required this.reviewedBy,
    required this.reviewNote,
    required this.date,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    final rawUser = json['userId'];
    String parsedUserId = '';
    String? parsedUserName;

    if (rawUser is Map<String, dynamic>) {
      parsedUserId =
          rawUser['_id']?.toString() ?? rawUser['id']?.toString() ?? '';
      parsedUserName = rawUser['name']?.toString();
    } else {
      parsedUserId = rawUser?.toString() ?? '';
    }

    return Expense(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      userId: parsedUserId,
      userName: parsedUserName,
      companyId: json['companyId']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'AED',
      amountBase: json['amountBase'],
      category: json['category'] ?? '',
      notes: json['notes'],
      receiptUrl: json['receiptUrl'],
      vatApplicable: json['vatApplicable'] ?? false,
      vatAmount: json['vatAmount'] ?? 0,
      paymentMethod: json['paymentMethod'],
      status: json['status'] ?? 'pending',
      reviewedBy: json['reviewedBy']?.toString(),
      reviewNote: json['reviewNote'],
      date: DateTime.parse(json['date']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'companyId': companyId,
        'amount': amount,
        'currency': currency,
        'amountBase': amountBase,
        'category': category,
        'notes': notes,
        'receiptUrl': receiptUrl,
        'vatApplicable': vatApplicable,
        'vatAmount': vatAmount,
        'paymentMethod': paymentMethod,
        'status': status,
        'reviewedBy': reviewedBy,
        'reviewNote': reviewNote,
        'date': date.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}

class ExpenseCreateDto {
  final num amount;
  final String currency;
  final String category;
  final String? notes;
  final bool vatApplicable;
  final num vatAmount;
  final String paymentMethod;
  final DateTime date;

  ExpenseCreateDto({
    required this.amount,
    required this.currency,
    required this.category,
    required this.notes,
    required this.vatApplicable,
    required this.vatAmount,
    required this.paymentMethod,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'category': category,
        'notes': notes,
        'vatApplicable': vatApplicable,
        'vatAmount': vatAmount,
        'paymentMethod': paymentMethod,
        'date': date.toIso8601String(),
      };
}
