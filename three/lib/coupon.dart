import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:three/globar_variable.dart';

class coupon extends StatefulWidget {
  const coupon({Key? key}) : super(key: key);

  @override
  State<coupon> createState() => _couponState();
}


String text_string = '';

class _couponState extends State<coupon> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generate_coupon();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage('assets/v.jpeg'),fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange, title: Text('Coupon'),),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Center(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      child: Card(
                        color: Colors.orangeAccent,
                          child: Center(
                              child: Text('$text_string', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          ),
                      ),
                    ),

                  ],
                ),
          )
        ),
      ),
    );
  }

  Future<void> generate_coupon() async {
    Map <String,dynamic> data;
    DocumentSnapshot from_db =
    await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
        .doc(global_EMP_CODE).get();
    if(from_db.exists) {
      int temp = int.parse(from_db['COUPON']);
      if(temp != 0){
        Fluttertoast.showToast(msg: "Already you have generated your coupon", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
        setState(() {
          global_text_string = "COUPON NO: " + from_db['COUPON'];
          text_string = "COUPON NO: " + from_db['COUPON'] ;
          return;
        });

      }else{
        DocumentSnapshot coupon_from_db =
        await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
            .doc('TOTAL_COUPON').get();
        if(coupon_from_db.exists){
          int total = int.parse(coupon_from_db['TOTAL_COUPON']);
          total = total + 1;
          Map <String,dynamic> total_data = {'TOTAL_COUPON':total.toString()};
          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
              .doc('TOTAL_COUPON').update(total_data);
          global_text_string = "COUPON NO: " + total.toString();
          //print("if" + global_text_string);
          Map <String,dynamic> data = {'COUPON': total.toString()};
          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
              .doc(global_EMP_CODE).update(data);
        }else{
          Map <String,dynamic> data1 = {'TOTAL_COUPON':'1','RATING': '0' };
          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
              .doc('TOTAL_COUPON').set(data1);
          Map <String,dynamic> data = {'COUPON': '1'};
          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
              .doc(global_EMP_CODE).update(data);
          global_text_string = "COUPON NO: 1";
        }
      }
      /*
      DocumentSnapshot coupon_from_db =
      await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
          .doc('TOTAL_COUPON').get();
      if(coupon_from_db.exists){
        int total = int.parse(coupon_from_db['TOTAL_COUPON']);
        total = total + 1;
        Map <String,dynamic> total_data = {'TOTAL_COUPON':total.toString()};
        FirebaseFirestore.instance.collection(global_CURRENT_DATE)
            .doc('TOTAL_COUPON').update(total_data);
        global_text_string = "COUPON NO: " + total.toString();
        //print("if" + global_text_string);
      }else{
        Map <String,dynamic> data = {'COUPON':'1'};
        FirebaseFirestore.instance.collection(global_CURRENT_DATE)
            .doc(global_EMP_CODE).update(data);
        Map <String,dynamic> data1 = {'TOTAL_COUPON':'1'};
        FirebaseFirestore.instance.collection(global_CURRENT_DATE)
            .doc('TOTAL_COUPON').set(data1);
        global_text_string = "COUPON NO: 1";
      }

       */
    }else{
      global_text_string = "Yesterday you didn't order";
      Fluttertoast.showToast(msg: "Yesterday you didn't order meal", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
    }
    setState(() {
      text_string = global_text_string;
    });

  }

}


