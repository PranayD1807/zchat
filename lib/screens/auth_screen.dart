import 'package:flutter/material.dart';
import 'package:zchat/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  // const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
              image: NetworkImage(
                  'https://img.wallpapersafari.com/desktop/1600/900/19/59/Pphai1.jpg'),
            ),
          ),
          child: AuthForm(_submitAuthForm)),
    );
  }
}
