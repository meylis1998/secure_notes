import 'package:get_it/get_it.dart';
import 'package:dio_client_handler/dio_client_handler.dart';

/// Global service locator
final injector = GetIt.instance;
Future<void> initServices() async {
  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

  // ─── Data Sources ─────────────────────────────────────────────────

  // ─── Repositories ─────────────────────────────────────────────────
}
