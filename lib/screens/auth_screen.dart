import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zchat/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  // const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (e) {
      var message = 'An error occured, please check your creadentials';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      var message = err.toString();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

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
          child: AuthForm(_submitAuthForm, _isLoading)),
    );
  }
}
