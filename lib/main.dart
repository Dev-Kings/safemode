import 'package:flutter/material.dart';
import 'package:qadata/screen/home.dart';
import 'package:qadata/screen/login.dart';
import 'package:qadata/vandad/constants/routes.dart';
import 'package:qadata/vandad/views/data/new_data_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q.A Data App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const CheckAuth(title: 'Q.A Data App'),
      routes: {
        newDataRoute:(context) => const NewDataView(),
        loginRoute:(context) => const Login(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = const Home();
    } else {
      child = const Login();
    }
    return Scaffold(
      body: child,
    );
  }
}
