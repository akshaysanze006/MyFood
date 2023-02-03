import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:three/globar_variable.dart';

class rating_list_view extends StatefulWidget {
  const rating_list_view({Key? key}) : super(key: key);

  @override
  State<rating_list_view> createState() => _rating_list_viewState();
}
String change_menu_ = 'menu', formatted_date = '';
//final CollectionReference _Employee_Details = FirebaseFirestore.instance.collection('Employee_Details');
class _rating_list_viewState extends State<rating_list_view> {
  @override
  Widget build(BuildContext context) {
    current_date1();
    get_foodmenu();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage('assets/v.jpeg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange, title: Text('Rating'),),
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: 40, left: 5, right: 5),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Center(
                  child: Card(
                    color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text(formatted_date, style: TextStyle(fontSize: 20),)),
                        SizedBox(height: 5,),
                        Center(child: Text(change_menu_,
                          style: TextStyle(fontSize: 20, color: Colors.white),)),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection(formatted_date)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot
                            .data!.docs[index];
                        return Card(
                          //margin: const EdgeInsets.all(10),
                          color: Colors.orangeAccent,
                          child: documentSnapshot['RATING'] != '0' ? ListTile(
                            title: Text(documentSnapshot['RATING']),
                            //title: Text(documentSnapshot['EMP CODE'].toString()),
                            //subtitle: Text(documentSnapshot['EMP NAME']),
                            //trailing: Text(documentSnapshot['DEPARTMENT']),
                          ) : cont(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),),
            ],
          ),

        ),
      ),
    );
  }

  void current_date1() {
    final today = DateTime.now();
    final today_ = DateFormat('EEEE, dd MMMM yyyy').format(
        today.add(const Duration(days: 1)));
    setState(() {
      formatted_date = today_;
    });
    //print(formatted_date);
  }

  void get_foodmenu() {
    String change_menu = '';
    final today = DateTime.now();
    final dayName = DateFormat('E').format(today.add(const Duration(days: 1)));
    //print(day_int);
    if (dayName == 'Mon') {
      change_menu = 'ചോറും മീൻ കറിയും';
      //print(day);
    } else if (dayName == 'Tue') {
      change_menu = 'നെയ്ച്ചോറ്';
    } else if (dayName == 'Wed') {
      change_menu = 'ചോറും മീൻ കറിയും';
    } else if (dayName == 'Thu') {
      change_menu = 'ചോറും ചിക്കൻ കറിയും';
    } else if (dayName == 'Fri') {
      change_menu = 'ചിക്കൻ‍ ബിരിയാണി';
    } else if (dayName == 'Sat') {
      final day = DateFormat('d').format(today.add(const Duration(days: 1)));
      int dayInt = int.parse(day);
      if (dayInt >= 8 && dayInt <= 12) {
        //global_Closed = "CLOSED";
        change_menu = '2nd Saturday';
        return;
      } else {
        change_menu = 'സദ്യ';
      }
    } else if (dayName == 'Sun') {
      //global_Closed = "CLOSED";
      change_menu = 'Holiday';
      return;
    }
    setState(() {
      change_menu_ = change_menu;
    });
  }
}
cont() {
  //dummy
}


