import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/appwrite/appwrite_client.dart';
import 'package:free_put/src/features/home/cubit/upload_cubit.dart';
import 'package:free_put/src/features/home/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppwriteClient.init();
  AppwriteClient.testConnection();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UploadCubit(), child: HomeScreen()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .light(primary: CupertinoColors.activeBlue),
      ),
      home: HomeScreen(),
    );
  }
}
