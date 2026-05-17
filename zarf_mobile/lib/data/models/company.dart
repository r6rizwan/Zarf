class Company {
  final String id;
  final String name;
  final String baseCurrency;
  final bool vatRegistered;
  final num vatRate;
  final String? vatNumber;

  Company({
    required this.id,
    required this.name,
    required this.baseCurrency,
    required this.vatRegistered,
    required this.vatRate,
    this.vatNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        name: json['name'] ?? '',
        baseCurrency: json['baseCurrency'] ?? 'AED',
        vatRegistered: json['vatRegistered'] ?? false,
        vatRate: json['vatRate'] ?? 0,
        vatNumber: json['vatNumber'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseCurrency': baseCurrency,
        'vatRegistered': vatRegistered,
        'vatRate': vatRate,
        'vatNumber': vatNumber,
      };
}
