import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:zchat/widgets/contacts/contacts.dart';
import 'package:zchat/widgets/drawer.dart';
import 'package:zchat/widgets/user_preview_widget.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String userName = '';
  String userPic = '';
  String userEmail = '';
  String userId = '';

  getUser(String email) async {
    // final userData = null;
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      final userdata =
          user.docs.firstWhere((element) => element['email'] == email);

      final cUser = FirebaseAuth.instance.currentUser!.uid;
      if (cUser == userdata.id) {
        setState(() {
          userName = 'error2';
        });
      } else {
        setState(() {
          userName = userdata['username'];
          userPic = userdata['image_url'];
          userEmail = userdata['email'];
          userId = userdata.id;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'error1';
      });
    }
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search User by Email...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      // debounceDelay: const Duration(milliseconds: 1000),
      onSubmitted: getUser,
      onQueryChanged: getUser,

      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: SizedBox(
              height: 100,
              child: Container(
                child: userName != ''
                    ? Container(
                        child: userName == 'error1'
                            ? const Center(child: Text('No user Found'))
                            : userName == 'error2'
                                ? const Center(
                                    child: Text('You can not add yourself'))
                                : Center(
                                    child: UserPreview(
                                      u2email: userEmail,
                                      u2image: userPic,
                                      u2username: userName,
                                      user2Id: userId,
                                    ),
                                  ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: XDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/img3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Contacts(),
            buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }
}
