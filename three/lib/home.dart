import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:three/nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:three/globar_variable.dart';


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String change_date = 'change date', change_menu = 'change menu',
      closed = "Tomorrow's Meal !", hi_name='';
  @override
  Widget build(BuildContext context) {
    current_date_fun();
    get_food_menu();
    setState(() {
      change_date = global_CURRENT_DATE;
      change_menu = global_Menu;
      closed = global_Closed;
      hi_name = global_EMP_NAME;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage('assets/v.jpeg'),fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: nav_bar(),
        appBar: AppBar(backgroundColor: Colors.deepOrange,title: Text('Home'),),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/myg.png'), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.only(top: 120),//for tomorrow meal
                  margin: EdgeInsets.all(5.0),
                  width: double.infinity,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(image: AssetImage('assets/food.jpg'), fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      Text("$closed", style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                      Text("$change_menu", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),),
                      Text("$change_date", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Hi "+"$hi_name", style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),),
                      SizedBox(height: 20,),

                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Do you need meal tomorrow ?", style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),),
                            SizedBox(height:10,),

                            //Order yes button
                            ElevatedButton(onPressed: () async {
                              /////////////check sun or 2nd sat////////////////////
                              final today = DateTime.now();
                              final day_name = DateFormat('E').format(today.add(const Duration(days: 1)));
                              if(day_name == 'Sat'){
                                final day = DateFormat('d').format(today.add(const Duration(days: 1)));
                                int day_int = int.parse(day);
                                if(day_int >= 8 && day_int <= 12){
                                  return;
                                }
                              }
                              else if(day_name == 'Sun'){
                                return;
                              }
                              ///////////////////////////////



                              DocumentSnapshot from_db =
                                  await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                  .doc(global_EMP_CODE).get();
                              if(from_db.exists){
                                Fluttertoast.showToast(msg: "Already Ordered", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                              }else{
                                showDialog(context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text("Order Confirmation", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                      content: Text("Are you sure", style: TextStyle(fontSize: 15),),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Text("NO", style: TextStyle(fontSize: 15),)),
                                        TextButton(onPressed: () async {
                                          //writing employee code to food count details
                                          Map <String,dynamic> data = {global_EMP_CODE:global_EMP_NAME, 'COUPON':'0', 'RATING':'0'};
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc(global_EMP_CODE).set(data);

                                          //
                                          DocumentSnapshot totat_from_db =
                                          await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc("TOTAL COUNT").get();
                                          if(totat_from_db.exists){
                                            int total = int.parse(totat_from_db['TOTAL COUNT']);
                                            total = total + 1;
                                            Map <String,dynamic> total_data = {'TOTAL COUNT':total.toString()};
                                            FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                                .doc("TOTAL COUNT").update(total_data);
                                          }else{
                                            Map <String,dynamic> total_data = {'TOTAL COUNT': "1", 'RATING': '0'};
                                            FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                                .doc("TOTAL COUNT").set(total_data);
                                          }





                                          //writing department count
                                          DocumentSnapshot from_db_dep =
                                          await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc(global_DEPARTMENT).get();
                                          if(from_db_dep.exists) {
                                            int count = int.parse(from_db_dep[global_DEPARTMENT]);
                                            count = count + 1;
                                            Map <String,dynamic> data = {global_DEPARTMENT: count.toString()};
                                            FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                                .doc(global_DEPARTMENT).update(data);
                                          }else{
                                            Map <String,dynamic> data = {global_DEPARTMENT: "1", 'RATING': '0'};
                                            FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                                .doc(global_DEPARTMENT).set(data);
                                          }

                                          Navigator.pop(context);
                                          Fluttertoast.showToast(msg: "Ordered Successfully", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);

                                        }, child: Text("YES", style: TextStyle(fontSize: 15),)),

                                      ],
                                    ));
                              }




                            },
                              style: ElevatedButton.styleFrom(primary: Colors.deepPurple[800]),
                              child: Text('Yes',
                              style: TextStyle(fontSize: 20,
                              color: Colors.white),),),

                            //cancellation button
                            TextButton(onPressed: () async {
                              /////////////check sun or 2nd sat////////////////////
                              final today = DateTime.now();
                              final day_name = DateFormat('E').format(today.add(const Duration(days: 1)));
                              if(day_name == 'Sat'){
                                final day = DateFormat('d').format(today.add(const Duration(days: 1)));
                                int day_int = int.parse(day);
                                if(day_int >= 8 && day_int <= 12){
                                  return;
                                }
                              }
                              else if(day_name == 'Sun'){
                                return;
                              }
                              ///////////////////////////////

                              DocumentSnapshot from_db =
                                  await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                  .doc(global_EMP_CODE).get();
                              if(from_db.exists){
                                showDialog(context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text("Cancellation Confirmation", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                      content: Text("Are you sure", style: TextStyle(fontSize: 15),),
                                      actions: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("NO", style: TextStyle(fontSize: 15),)),
                                      TextButton(onPressed: () async {
                                      //Removing employee code from food count details
                                      FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                          .doc(global_EMP_CODE).delete();

                                      //decreasing total count
                                      DocumentSnapshot totat_from_db =
                                      await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                          .doc("TOTAL COUNT").get();
                                      if(totat_from_db.exists){
                                        int total = int.parse(totat_from_db['TOTAL COUNT']);
                                        total = total - 1;
                                        if(total == 0){
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc("TOTAL COUNT").delete();
                                        }else{
                                          Map <String,dynamic> total_data = {'TOTAL COUNT':total.toString()};
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc("TOTAL COUNT").update(total_data);
                                        }


                                        }


                                      //decreasing department count
                                      DocumentSnapshot from_db_dep =
                                      await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                          .doc(global_DEPARTMENT).get();
                                      if(from_db_dep.exists) {
                                        int count = int.parse(from_db_dep[global_DEPARTMENT]);
                                        count = count - 1;
                                        if(count == 0) {
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc(global_DEPARTMENT).delete();
                                          }else{
                                            Map <String,dynamic> data = {global_DEPARTMENT: count.toString()};
                                            FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                                .doc(global_DEPARTMENT).update(data);
                                          }
                                      }
                                      /////////////////////
                                      DocumentSnapshot coupon_from_db =
                                      await FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                          .doc('TOTAL_COUPON').get();
                                      if(coupon_from_db.exists){
                                        int total = int.parse(coupon_from_db['TOTAL_COUPON']);
                                        total = total - 1;
                                        if(total == 0){
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc('TOTAL_COUPON').delete();
                                        }else{
                                          Map <String,dynamic> total_data = {'TOTAL_COUPON':total.toString()};
                                          FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                                              .doc('TOTAL_COUPON').update(total_data);
                                        }


                                      }

                                      ///////////////////



                                      Fluttertoast.showToast(msg: "Ordered Cancelled", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                      Navigator.pop(context);
                                      }, child: Text("YES", style: TextStyle(fontSize: 15),)),

                                      ],
                                      ));

                              }else{
                                Fluttertoast.showToast(msg: "No Ordered Present", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                              }



                            }, child: Text('Cancellation', style: TextStyle(color: Colors.grey[900]),),)


                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),



      ),

    );

  }
}


void get_food_menu() {
  final today = DateTime.now();
  final day_name = DateFormat('E').format(today.add(const Duration(days: 1)));
  //print(day_int);
  if(day_name == 'Mon'){
    global_Menu = 'ചോറും മീൻ കറിയും';
    //print(day);
  }else if(day_name == 'Tue'){
    global_Menu = 'നെയ്ച്ചോറ്';
  }else if(day_name == 'Wed'){
    global_Menu = 'ചോറും മീൻ കറിയും';
  }else if(day_name == 'Thu'){
    global_Menu = 'ചോറും ചിക്കൻ കറിയും';
  }else if(day_name == 'Fri'){
  global_Menu = 'ചിക്കൻ‍ ബിരിയാണി';
  }else if(day_name == 'Sat'){
    final day = DateFormat('d').format(today.add(const Duration(days: 1)));
    int day_int = int.parse(day);
    if(day_int >= 8 && day_int <= 12){
      global_Closed = "CLOSED";
      global_Menu = '2nd Saturday';
      return;
    }else{
      global_Menu = 'സദ്യ';
    }
  }else if(day_name == 'Sun'){
    global_Closed = "CLOSED";
    global_Menu = 'Holiday';
    return;
  }

}

void current_date_fun() async{
  final today = DateTime.now();
  final tomorrow = DateFormat('EEEE, dd MMMM yyyy').format(today.add(const Duration(days: 1)));
  global_CURRENT_DATE = tomorrow;
  //print(yesterday);

}


