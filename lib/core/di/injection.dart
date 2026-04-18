import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  // ** Lazy singleton: a single DioClient is shared app-wide so the connection
  // ** pool and interceptor config are reused; built on first access since no
  // ** code needs Dio before the first network request.
  getIt.registerLazySingleton<DioClient>(() => DioClient());
}
