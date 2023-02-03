import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:three/globar_variable.dart';

class food_count_list extends StatefulWidget {
  const food_count_list({Key? key}) : super(key: key);

  @override
  State<food_count_list> createState() => _food_count_listState();
}

class _food_count_listState extends State<food_count_list> {

  String display_string = '';
  String _formatted_date = 'Select date', change_menu = '';


  @override
  Widget build(BuildContext context) {
    //String _formatted_date = DateFormat('EEEE, dd MMMM yyyy').format(_currentdate);

    //String _formatted_date = 'Select Date';


    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/v.jpeg'), fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange, title: Text('Food Count List'),),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Center(child: Text('$_formatted_date')),
              Column(
                children: [
                  TextButton(onPressed: () async {
                    display_string = "";
                    DateTime _currentdate = new DateTime.now();
                    final DateTime? _seldate = await showDatePicker(
                      context: context,
                      initialDate: _currentdate,
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2025),
                    );
                    if (_seldate != null) {

                      setState(() {
                        _currentdate = _seldate;
                        _formatted_date =
                            DateFormat('EEEE, dd MMMM yyyy').format(
                                _currentdate);
                      });
                      ///////////Change Menu//////////////////
                      final day_name = DateFormat('E').format(_currentdate);
                      //print(day_int);
                      if(day_name == 'Mon'){
                        change_menu = 'ചോറും മീൻ കറിയും';
                        //print(day);
                      }else if(day_name == 'Tue'){
                        change_menu = 'നെയ്ച്ചോറ്';
                      }else if(day_name == 'Wed'){
                        change_menu = 'ചോറും മീൻ കറിയും';
                      }else if(day_name == 'Thu'){
                        change_menu = 'ചോറും ചിക്കൻ കറിയും';
                      }else if(day_name == 'Fri'){
                        change_menu = 'ചിക്കൻ‍ ബിരിയാണി';
                      }else if(day_name == 'Sat'){
                        final day = DateFormat('d').format(_currentdate);
                        int day_int = int.parse(day);
                        if(day_int >= 8 && day_int <= 12){
                          change_menu = '2nd Saturday';
                        }else{
                          change_menu = 'സദ്യ';
                        }
                      }else if(day_name == 'Sun'){
                        change_menu = 'Holiday';
                      }
                      ////////////////////////////





                    }

                  },
                    child: Text('$_formatted_date', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),),),
                  Text('$change_menu',style: TextStyle(fontSize: 18),),
                  ElevatedButton(onPressed: () async {
                    List<String> data_string = ['', '', ''];
                    int j = 0;
                    for (int i = 0; i < global_string.length; i++) {
                      DocumentSnapshot data = await FirebaseFirestore.instance
                          .collection(
                          _formatted_date)
                          .doc(global_string[i]).get();
                      if (data.exists) {
                        //print( global_string[i] +" :  " + data[global_string[i]]);
                        data_string[j] =
                            global_string[i] + " :  " + data[global_string[i]];
                        j++;
                      }
                    }
                    if (j == 0) {
                      data_string[0] = "No Data Present";
                    } else {
                      DocumentSnapshot data = await FirebaseFirestore.instance
                          .collection(
                          _formatted_date)
                          .doc("TOTAL COUNT").get();
                      data_string[j] = "---------------\nTotal Count" + " :  " +
                          data["TOTAL COUNT"];
                    }

                    setState(() {
                      display_string = data_string.join('\n');
                      //print(data_string);
                      //print(display_string);
                    });
                  },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple[800]),
                    child: Text("Show Data"),),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text('$display_string',
                    style: TextStyle(color: Colors.black, fontSize: 17),),
                ),
              ),

            ],
          ),
        ),


      ),
    );
  }

}
