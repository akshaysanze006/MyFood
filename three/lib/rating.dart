import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:three/globar_variable.dart';
import 'package:three/home.dart';

class my_rating extends StatefulWidget {
  const my_rating({Key? key}) : super(key: key);

  @override
  State<my_rating> createState() => _my_ratingState();
}
String change_menu = 'menu', formatted_date = 'date', save_status ='SAVE';
bool is_loading = false;
class _my_ratingState extends State<my_rating> {
final rating_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    current_date();
    get_foodmenu();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: AssetImage('assets/v.jpeg'),fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange, title: Text('Rating'),),
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Center(
                  child: Text('$formatted_date', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),),
                ),
                SizedBox(height: 10,),
                Center(child: Text('$change_menu',style: TextStyle(fontSize: 18),)),
                SizedBox(height: 50,),
                TextField(
                  controller: rating_controller,
                  decoration: InputDecoration(
                  hintText: 'Write your Review',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(onPressed: () async {
                  if(rating_controller.text.isNotEmpty){
                    DocumentSnapshot from_db =
                        await FirebaseFirestore.instance.collection(formatted_date)
                        .doc(global_EMP_CODE).get();
                    if(from_db.exists){
                      String temp = from_db['RATING'];
                      if(temp == '0'){
                        Map <String,dynamic> data = {'RATING': rating_controller.text};
                        FirebaseFirestore.instance.collection(global_CURRENT_DATE)
                            .doc(global_EMP_CODE).update(data);
                        setState(() {
                          is_loading = true;
                        });
                        Future.delayed(const Duration(milliseconds: 1000),(){
                          setState(() {
                            is_loading = false;
                            save_status = 'SAVED';
                            //rating_controller.clear();
                            Fluttertoast.showToast(msg: "Review Successfully Saved",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.redAccent, textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        });

                        Fluttertoast.showToast(msg: "Review Successfully Saved",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.redAccent, textColor: Colors.white,
                            fontSize: 16.0);

                      }else{
                        Fluttertoast.showToast(msg: "Already you have given your review",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.redAccent, textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }else{
                      Fluttertoast.showToast(msg: "Today you didn't order meal",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.redAccent, textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  }else{
                    Fluttertoast.showToast(msg: "Please write your Review",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.redAccent, textColor: Colors.white,
                        fontSize: 16.0);
                  }

                }, child: is_loading ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color:
                    Colors.white,),
                ) : Text('$save_status')),
              ],
            ),
          ),
        ),
      );
  }



  void get_foodmenu() {
    final today = DateTime.now();
    final dayName = DateFormat('E').format(today.add(const Duration(days: 1)));
    //print(day_int);
    if(dayName == 'Mon'){
      change_menu = 'ചോറും മീൻ കറിയും';
      //print(day);
    }else if(dayName == 'Tue'){
      change_menu = 'നെയ്ച്ചോറ്';
    }else if(dayName == 'Wed'){
      change_menu = 'ചോറും മീൻ കറിയും';
    }else if(dayName == 'Thu'){
      change_menu = 'ചോറും ചിക്കൻ കറിയും';
    }else if(dayName == 'Fri'){
      change_menu = 'ചിക്കൻ‍ ബിരിയാണി';
    }else if(dayName == 'Sat'){
      final day = DateFormat('d').format(today.add(const Duration(days: 1)));
      int dayInt = int.parse(day);
      if(dayInt >= 8 && dayInt <= 12){
        //global_Closed = "CLOSED";
        change_menu = '2nd Saturday';
        return;
      }else{
        change_menu = 'സദ്യ';
      }
    }else if(dayName == 'Sun'){
      //global_Closed = "CLOSED";
      change_menu = 'Holiday';
      return;
    }

  }
  void current_date() {
    final today = DateTime.now();
    final today_ = DateFormat('EEEE, dd MMMM yyyy').format(today.add(const Duration(days: 1)));
    setState(() {
      formatted_date = today_;
    });
  }

}


