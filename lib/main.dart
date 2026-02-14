import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/app/root_router.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   // colorScheme: ColorScheme.fromSeed(
      //   //   seedColor: Color.fromRGBO(27, 179, 148, 1),
      //   // ),
      // ),
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const RootRouter(),
    );
  }
}
