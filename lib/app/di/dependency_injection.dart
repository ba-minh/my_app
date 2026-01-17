import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thư viện lưu trữ

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
import '../../data/datasources/remote/device_mock_datasource.dart'; 
import '../../data/datasources/local/device_local_datasource.dart'; // Import Local DS
import '../../data/repositories/device_repository_impl.dart';
import '../../data/datasources/local/command_queue_local_datasource.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_user_devices_usecase.dart'; 
import '../../features/dashboard/presentation/blocs/device_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // 0. CORE / EXTERNAL
  // ==========================
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  
  // [MỚI] SharedPreferences (Lưu ý: Phải dùng await)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ==========================
  // 1. FEATURE: AUTH
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
    )
  );
  // Command Queue Local (Store & Forward)
  sl.registerLazySingleton<CommandQueueLocalDataSource>(
    () => CommandQueueLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================
  // 2. FEATURE: DEVICE (IoT)
  // ==========================

  // --- Data Source ---
  // Remote (Mock/API)
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceMockDataSourceImpl(),
  );

  // [MỚI] Local (Cache)
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // --- Repository ---
  // [CẬP NHẬT] Tiêm cả Remote và Local vào Repository
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(), // Thêm dòng này
    ),
  );

  // --- Use Cases ---
  sl.registerLazySingleton(() => GetUserDevicesUseCase(sl()));

  // --- Blocs ---
  sl.registerFactory(() => DeviceBloc(getUserDevicesUseCase: sl())); 
}