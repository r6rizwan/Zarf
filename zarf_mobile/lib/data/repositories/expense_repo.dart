import '../models/company.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseRepo {
  final api = ApiService.instance;

  Future<Map<String, dynamic>> getExpenses({
    String? status,
    String? from,
    String? to,
    String? category,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
  }) async {
    final query = {
      'page': page,
      'limit': limit,
      if (status != null && status.isNotEmpty) 'status': status,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (category != null && category.isNotEmpty) 'category': category,
      if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
      if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
    };

    final res = await api.dio.get('/expenses', queryParameters: query);
    return {
      'data':
          (res.data['data'] as List).map((e) => Expense.fromJson(e)).toList(),
      'total': res.data['total'],
      'page': res.data['page'],
      'totalPages': res.data['totalPages'],
    };
  }

  Future<Expense> createExpense(ExpenseCreateDto dto) async {
    final res = await api.dio.post('/expenses', data: dto.toJson());
    return Expense.fromJson(res.data['data']);
  }

  Future<Expense> getExpenseById(String id) async {
    final res = await api.dio.get('/expenses/$id');
    return Expense.fromJson(res.data['data']);
  }

  Future<Expense> updateStatus(
      String id, String status, String? reviewNote) async {
    final res = await api.dio.patch('/expenses/$id/status', data: {
      'status': status,
      'reviewNote': reviewNote,
    });
    return Expense.fromJson(res.data['data']);
  }

  Future<void> deleteExpense(String id) async {
    await api.dio.delete('/expenses/$id');
  }

  Future<Company> getCompanyById(String companyId) async {
    final res = await api.dio.get('/company/$companyId');
    return Company.fromJson(res.data['data']);
  }
}
