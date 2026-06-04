import '../models/company.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseRepo {
  final api = ApiService.instance;
  final Map<String, ({DateTime ts, Map<String, dynamic> data})> _cache = {};
  static const _cacheTtl = Duration(seconds: 45);

  Future<Map<String, dynamic>> getExpenses({
    String? status,
    String? from,
    String? to,
    String? category,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
    bool useCache = true,
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

    final cacheKey = query.toString();
    final cached = _cache[cacheKey];
    if (useCache &&
        cached != null &&
        DateTime.now().difference(cached.ts) < _cacheTtl) {
      return cached.data;
    }

    final res = await api.dio.get('/expenses', queryParameters: query);
    final parsed = {
      'data':
          (res.data['data'] as List).map((e) => Expense.fromJson(e)).toList(),
      'total': res.data['total'],
      'page': res.data['page'],
      'totalPages': res.data['totalPages'],
    };
    _cache[cacheKey] = (ts: DateTime.now(), data: parsed);
    return parsed;
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
