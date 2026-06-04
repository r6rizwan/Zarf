import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String downloadUrl;
  final String releaseUrl;

  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseUrl,
  });
}

class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  static const _latestReleaseApi =
      'https://api.github.com/repos/r6rizwan/Zarf/releases/latest';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/vnd.github+json'},
    ),
  );

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _dio.get(_latestReleaseApi);
      final data = response.data as Map<String, dynamic>;

      final tagName = (data['tag_name'] ?? '').toString();
      final latestVersion = _normalizeVersion(tagName);
      if (latestVersion.isEmpty) return null;

      if (!_isVersionNewer(currentVersion, latestVersion)) {
        return null;
      }

      final releaseUrl = (data['html_url'] ?? '').toString();
      final assets = (data['assets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final directApkUrl = _pickBestApkUrl(assets);

      return UpdateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        downloadUrl: directApkUrl ?? releaseUrl,
        releaseUrl: releaseUrl,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> openDownload(UpdateInfo info) async {
    final uri = Uri.parse(info.downloadUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    final fallbackUri = Uri.parse(info.releaseUrl);
    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  String _normalizeVersion(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.startsWith('v') || trimmed.startsWith('V')
        ? trimmed.substring(1)
        : trimmed;
  }

  bool _isVersionNewer(String current, String latest) {
    final currentParts = _parseVersion(current);
    final latestParts = _parseVersion(latest);

    for (var i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    final core = version.split('+').first;
    final parts = core.split('.');
    return List<int>.generate(3, (index) {
      if (index >= parts.length) return 0;
      return int.tryParse(parts[index]) ?? 0;
    });
  }

  String? _pickBestApkUrl(List<Map<String, dynamic>> assets) {
    final apkAssets = assets.where((asset) {
      final name = (asset['name'] ?? '').toString().toLowerCase();
      return name.endsWith('.apk');
    }).toList();

    if (apkAssets.isEmpty) return null;

    for (final preferred in ['arm64', 'universal', 'release']) {
      for (final asset in apkAssets) {
        final name = (asset['name'] ?? '').toString().toLowerCase();
        if (name.contains(preferred)) {
          return (asset['browser_download_url'] ?? '').toString();
        }
      }
    }

    return (apkAssets.first['browser_download_url'] ?? '').toString();
  }
}
