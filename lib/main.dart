import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import 'core_ui/theme/app_theme.dart';
import 'app/di/dependency_injection.dart' as di;
import 'app/di/dependency_injection.dart'; 
import 'app/router/app_router.dart';

// Import Auth Bloc
import 'features/auth/presentation/blocs/auth_bloc.dart'; 
import 'features/auth/presentation/blocs/auth_event.dart'; 

// 👇 MỚI: Import Device Bloc
import 'features/dashboard/presentation/blocs/device_bloc.dart';

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
        // 1. Auth Bloc (Cũ)
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),

        // 👇 2. MỚI: Cung cấp DeviceBloc (Nhà kho thiết bị)
        BlocProvider<DeviceBloc>(
          create: (context) => DeviceBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'IoT Farm App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}