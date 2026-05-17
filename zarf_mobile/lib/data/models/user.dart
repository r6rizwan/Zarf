class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String companyId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.companyId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'employee',
        companyId: json['companyId']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'companyId': companyId,
      };
}
