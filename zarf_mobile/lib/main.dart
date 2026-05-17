import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'data/services/api_service.dart';

void main() {
  ApiService.instance.init(appRouter: AppRouter.router);
  runApp(const ZarfApp());
}

class ZarfApp extends StatelessWidget {
  const ZarfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp.router(
        title: 'Zarf',
        routerConfig: AppRouter.router,
      ),
    );
  }
}
