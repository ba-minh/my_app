import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// --- Auth Imports ---
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../domain/usecases/sign_up_usecase.dart'; 
import '../../domain/usecases/reset_password_usecase.dart'; 
import '../../domain/usecases/sign_in_google_usecase.dart'; 
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

// --- Device (IoT) Imports ---
import '../../data/datasources/remote/device_mock_datasource.dart'; // Import Mock Data
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_user_devices_usecase.dart'; 
import '../../features/dashboard/presentation/blocs/device_bloc.dart'; // ✅ ĐÃ BỎ COMMENT

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // 1. EXTERNAL (Firebase)
  // ==========================
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ==========================
  // 2. FEATURE: AUTH
  // ==========================
  
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl())); 
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignInGoogleUseCase(sl())); 
  sl.registerLazySingleton(() => CheckAuthUseCase(sl())); 
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        resetPasswordUseCase: sl(),
        signInGoogleUseCase: sl(),
        checkAuthUseCase: sl(),
        signOutUseCase: sl(),
      ));

  // ==========================
  // 3. FEATURE: DEVICE (IoT)
  // ==========================

  // Data Source
  // Lưu ý: Đang dùng MockDataSourceImpl. Khi nào có Backend thật thì đổi thành DeviceRemoteDataSourceImpl
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceMockDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUserDevicesUseCase(sl()));

  // Blocs
  // ✅ ĐÃ BỎ COMMENT: Đăng ký Bloc để sử dụng ở UI
  sl.registerFactory(() => DeviceBloc(getUserDevicesUseCase: sl())); 
}