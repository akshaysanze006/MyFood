import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:three/globar_variable.dart';


class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool hidden_password = true, ischecked = true;
  final emp_code_controller = TextEditingController();
  final password_controller = TextEditingController();
  late Box box1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CreateBox();

  }
  void CreateBox () async{
    box1 = await Hive.openBox('loginDB');//Hive database name loginDB
    GetBoxData();
  }

  @override
  Widget build(BuildContext context) {

    //String enterEMP_CODE = '', enterPASSWORD = '';




    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/v.jpeg'), fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Text('myG', style: TextStyle(
                  fontSize: 53, color: Colors.white,
                ),),
              ),
              Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.35, right: 35, left: 35),
                  child: Column(
                    children: [
//Text field EMP_CODE
                      TextField(
                        controller: emp_code_controller,
                        decoration: InputDecoration(
                            hintText: 'Employee Code',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                      SizedBox(height: 30,),

//Text field password
                      TextField(
                        controller: password_controller,
                        obscureText: hidden_password,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            suffixIcon: GestureDetector(
                              onTap:(){
                                setState(() {
                                  hidden_password = !hidden_password;
                                });
                              },
                                child: Icon(hidden_password ? Icons.visibility_off : Icons.visibility)
                            ),//gesture detector for button click
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Sign In', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              onPressed: ()   async {
                                if(emp_code_controller.text.isEmpty){
                                  Fluttertoast.showToast(msg: "Please enter Employee Code", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                }
                                else{
                                  DocumentSnapshot variable =
                                  await FirebaseFirestore.instance.collection('Employee_Details')
                                      .doc(emp_code_controller.text).get();
                                  if(variable.exists){
                                    print(variable['EMP NAME']);
                                    if(password_controller.text.isNotEmpty){
                                      if(password_controller.text == variable['PASSWORD']){
                                          StoreBoxData();// to save login details

                                        //Saving employee details to global variable
                                        global_EMP_CODE = variable['EMP CODE'];
                                        global_EMP_NAME = variable['EMP NAME'];
                                        global_PASSWORD = variable['PASSWORD'];
                                        global_DEPARTMENT = variable['DEPARTMENT'];
                                        global_MOB = variable['MOB'];

                                        Navigator.pushNamed(context, 'home');
                                        //Get.to(MyHome());
                                        Fluttertoast.showToast(msg: "Login Successful", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "Incorrect Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                      }
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "Please enter Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: "Invalid Employee code", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                  }
                                }


                              }, icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],



                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Remember Me', style: TextStyle(color: Colors.black54),),
                              Checkbox(
                                    value: ischecked,
                                    onChanged: (value){
                                      setState(() {
                                        ischecked = !ischecked;
                                      });
                                    }),
                            ]
                          ),
                          SizedBox(height: 30,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: (){
                                Navigator.pushNamed(context, 'change_password');// go to next change password
                              }, child: Text('Change Password     ', style: TextStyle(color: Colors.black54),)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void StoreBoxData() {
    if(ischecked){
      box1.put('stored_EMP_CODE', emp_code_controller.text);
      box1.put('stored_PASSWORD', password_controller.text);
    }else{
      box1.put('stored_EMP_CODE', null);
      box1.put('stored_PASSWORD', null);
    }
  }

  void GetBoxData() async {
    if (box1.get('stored_EMP_CODE') != null) {
      emp_code_controller.text = box1.get('stored_EMP_CODE');
      setState(() {
        ischecked = true;
      });
    } else {
      setState(() {
        ischecked = false;
      });
    }
    if (box1.get('stored_PASSWORD') != null) {
      password_controller.text = box1.get('stored_PASSWORD');
      setState(() {
        ischecked = true;
      });
    } else {
      setState(() {
        ischecked = false;
      });
    }
  }
}
