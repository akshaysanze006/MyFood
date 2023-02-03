

import 'package:three/coupon.dart';
import 'package:three/qr_coupon.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three/change_password.dart';
import 'package:three/food_count_list.dart';
import 'package:three/login.dart';
import 'package:three/home.dart';
import 'package:three/qr_coupon.dart';
import 'package:three/qr_test.dart';
import 'package:three/rating.dart';
import 'package:three/rating_list_view.dart';
import 'firebase_options.dart';
import 'package:three/nav_bar.dart';


void main() async{
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => MyLogin(),
      'home' : (context) => MyHome(),
      'change_password' : (context) => Mychange_password(),
      'nav_bar' : (context) => nav_bar(),
      'food_count_list' : (context) => food_count_list(),
      'qr_coupon' : (context) => qr_coupon(),
      'coupon' : (context) => coupon(),
      'rating' : (context) => my_rating(),
      'rating_list_view' : (context) => rating_list_view(),
      'qr_test' : (context) => qr_test(),

    },
  ));

}

