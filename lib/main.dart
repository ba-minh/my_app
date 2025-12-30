import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import 'app/di/dependency_injection.dart' as di;
import 'app/di/dependency_injection.dart'; 
import 'app/router/app_router.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Khởi tạo Firebase
  await Firebase.initializeApp();
  // 2. Khởi tạo Dependency Injection
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. BỌC TOÀN BỘ APP TRONG KHO CHỨA BLOC (MultiBlocProvider)
    return MultiBlocProvider(
      providers: [
        // Cung cấp AuthBloc cho toàn bộ ứng dụng dùng chung
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'IoT Farm App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF055B1D)),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme, 
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}