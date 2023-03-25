import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'purpoza/modules/home_activity/home_activity.dart';
import 'purpoza/modules/init_activities/signin_activity/signin_activity.dart';
import 'purpoza/shared/sharedpreferences_helper/sharedpreferences.dart';
import 'purpoza/statemanagement/statemanegment_bloc_observer/bloc_observer.dart';
import 'purpoza/styles/theme_activity.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await SharedPreferenceHelper.init();
  var uId = SharedPreferenceHelper.getData(key: 'uId');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  Widget? startWidget;
  (uId != null)
      ? startWidget = const HomeActivity()
      : startWidget = SignInActivity();

  runApp(MyApp(startWidget));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Widget? startWidget;
  MyApp(this.startWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purpoza',
      theme: lightTheme,
      home: startWidget,
    );
  }
}
