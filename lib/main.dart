import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swp/utils/moofiy_color.dart';
import 'firebase_options.dart';
import 'widgets/root_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const FixMyEnglishApp());
}

class FixMyEnglishApp extends StatelessWidget {
  const FixMyEnglishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix my English',
      theme: MoofiyColors.themeData,
      home: const RootWidget(),
    );
  }
}
