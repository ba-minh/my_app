import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../domain/usecases/sign_up_usecase.dart'; 
import '../../domain/usecases/reset_password_usecase.dart'; 
import '../../domain/usecases/sign_in_google_usecase.dart'; 
// 👇 Import 2 UseCase mới
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- 1. External ---
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // --- 2. Data Source ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // --- 3. Repository ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // --- 4. Use Cases ---
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl())); 
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignInGoogleUseCase(sl())); 
  // 👇 Đăng ký 2 UseCase mới
  sl.registerLazySingleton(() => CheckAuthUseCase(sl())); 
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  // --- 5. Blocs ---
  sl.registerFactory(() => AuthBloc(
          signInUseCase: sl(),
          signUpUseCase: sl(),
          resetPasswordUseCase: sl(),
          signInGoogleUseCase: sl(),
          checkAuthUseCase: sl(), // 👇 Tiêm vào Bloc
          signOutUseCase: sl(),   // 👇 Tiêm vào Bloc
        ));
}