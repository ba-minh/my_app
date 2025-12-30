import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Import các file bạn đã tạo ở các giờ trước
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../domain/usecases/sign_up_usecase.dart'; 
import '../../domain/usecases/reset_password_usecase.dart'; 

// Khởi tạo biến sl (Service Locator) để dùng toàn cục
final sl = GetIt.instance;

Future<void> init() async {
  // --- 1. External (Các thư viện bên ngoài) ---
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // --- 2. Data Source (Nguồn dữ liệu) ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // --- 3. Repository (Kho chứa) ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // --- 4. Use Cases (Logic nghiệp vụ) ---
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl())); 
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl())); 

  // --- 5. Blocs (Quản lý trạng thái) ---
  sl.registerFactory(() => AuthBloc(
          signInUseCase: sl(),
          signUpUseCase: sl(),
          resetPasswordUseCase: sl(),
        ));
}