import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/api_service.dart';
import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ApiService.instance.init(appRouter: AppRouter.router);

  // Wake up the backend server immediately on application startup
  ApiService.instance.dio.get('/health').catchError((e) {
    debugPrint('Startup server wake-up ping failed: $e');
    return Response(requestOptions: RequestOptions(path: '/health'));
  });

  await NotificationService.instance.init();
  runApp(const ZarfApp());
}

class ZarfApp extends StatelessWidget {
  const ZarfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zarf',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
