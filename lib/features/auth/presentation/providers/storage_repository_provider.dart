import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/storage_service_impl.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return SharedPreferencesStorageServiceImpl();
});
