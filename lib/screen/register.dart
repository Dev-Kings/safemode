// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qadata/screen/home.dart';
import 'package:qadata/screen/login.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var clockNumber;
  var firstname;
  var lastname;
  var email;
  var password;
  var passwordConfirmation;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.deepOrange,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: const TextStyle(color: Colors.lightBlue),
                                cursorColor: Colors.amber,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.pin,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Clock Number",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (clockNumberValue) {
                                  if (clockNumberValue!.isEmpty) {
                                    return 'Please enter your clock number';
                                  }
                                  clockNumber = clockNumberValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                cursorColor: Colors.purple,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "First Name",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (firstnameValue) {
                                  if (firstnameValue!.isEmpty) {
                                    return 'Please enter your firstname';
                                  }
                                  firstname = firstnameValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                cursorColor: Colors.purple,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Last Name",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (lastnameValue) {
                                  if (lastnameValue!.isEmpty) {
                                    return 'Please enter your lastname';
                                  }
                                  lastname = lastnameValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                cursorColor: Colors.purple,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (emailValue) {
                                  if (emailValue!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                cursorColor: Colors.purple,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue!.isEmpty) {
                                    return 'Please enter your preferred password';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                cursorColor: Colors.purple,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue!.isEmpty) {
                                    return 'Please enter your password confirmation';
                                  }
                                  passwordConfirmation = passwordValue;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.teal),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                      ),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey;
                                        }
                                        return Colors.orangeAccent;
                                      }),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _register();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Processing...' : 'Register',
                                      textDirection: TextDirection.ltr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: const Text(
                          'Already have an account ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'clock_number': clockNumber,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
