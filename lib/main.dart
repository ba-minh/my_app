import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import 'core_ui/theme/app_theme.dart';
import 'app/di/dependency_injection.dart' as di;
import 'app/di/dependency_injection.dart'; 
import 'app/router/app_router.dart';

import 'features/auth/presentation/blocs/auth_bloc.dart'; 
import 'features/auth/presentation/blocs/auth_event.dart'; 
import 'features/dashboard/presentation/blocs/device_bloc.dart';
import 'core_ui/blocs/connectivity/connectivity_bloc.dart'; 

import 'app/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. Auth Bloc
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),

        // 2. Device Bloc (Nhà kho thiết bị)
        BlocProvider<DeviceBloc>(
          create: (context) => sl<DeviceBloc>()..add(LoadDevices()),
        ),

        // 3. Connectivity Bloc (Mạng)
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc()..add(ConnectivityObserve()),
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