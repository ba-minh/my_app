import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import 'app/di/dependency_injection.dart' as di;
import 'app/di/dependency_injection.dart'; 
import 'app/router/app_router.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart'; 
// 👇 1. Cần import thêm file Event để dùng được AuthCheckRequested
import 'features/auth/presentation/blocs/auth_event.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          // 👇 2. SỬA DÒNG NÀY: Thêm 2 dấu chấm và lệnh add()
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
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