import 'package:dars_90_vazifa/data/model/user_model.dart';
import 'package:dars_90_vazifa/data/repositories/user_repositories.dart';
import 'package:dars_90_vazifa/ui/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({super.key});

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userFirebaseService = UserRepository();
  User? _user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        if (user != null) {
          _checkTokenValidity(user);
        }
      });
    });
  }

  Future<void> _checkTokenValidity(User user) async {
    try {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      DateTime? expirationTime = tokenResult.expirationTime;
      if (expirationTime != null && expirationTime.isBefore(DateTime.now())) {
        await auth.signOut();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 260.h,
                width: double.infinity,
                color: Colors.blue,
                child: _user == null
                    ? Center(
                        child: Text('User Not Found',
                            style: TextStyle(color: Colors.white)))
                    : StreamBuilder<DocumentSnapshot>(
                        stream: userFirebaseService.getUserById(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.white)),
                            );
                          }

                          final userDoc = snapshot.data!;
                          if (!userDoc.exists) {
                            return Center(
                              child: Text(
                                  'User Doesn\'t exist',
                                  style: TextStyle(color: Colors.white)),
                            );
                          }
                          final user = UserModel.fromDocumentSnapshot(userDoc);

                          final firstName = user.firstname;
                          final lastName = user.lastname;
                          final email = user.email;

                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user.imageUrl != null &&
                                    user.imageUrl.isNotEmpty)
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(user.imageUrl),
                                  ),
                                SizedBox(height: 10.h),
                                Text(
                                  '$firstName $lastName',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          ListTile(
            onTap: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Chiqish'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
