import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskbunny/Bloc/task_bloc.dart';
import 'package:taskbunny/Bloc/task_event.dart';
import 'package:taskbunny/core/constant/app_constant.dart';
import 'package:taskbunny/firebase_options.dart';
import 'package:taskbunny/screen.dart/Repository/task_repository.dart';
import 'package:taskbunny/screen.dart/UI/home_screen.dart';
import 'package:taskbunny/screen.dart/theme/color.dart';
import 'screen.dart/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(430, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const TaskManagerApp();
      },
    ),
  );
}
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LocalTaskRepository(),
      child: BlocProvider(
        create: (context) => TaskBloc(
          taskRepository: context.read<LocalTaskRepository>(),
        )..add(const LoadTasks()),
        child: MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}