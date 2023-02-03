import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Mychange_password extends StatefulWidget {
  const Mychange_password({Key? key}) : super(key: key);

  @override
  State<Mychange_password> createState() => _Mychange_passwordState();
}

class _Mychange_passwordState extends State<Mychange_password> {
  String enterEMP_CODE = '', enterPASSWORD = '', enterNEW_PASSWORD = '', enterCONFIRM_PASSWORD = '';
  bool hidden_password = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/v.jpeg'), fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepOrange,title: Text('Change Password'),),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 70, left: 35, right: 35),
          child: Column(
            children: [
              TextField(
                onChanged: (value){
                  enterEMP_CODE = value;
                },
                decoration: InputDecoration(
                  hintText: 'Employee Code',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                onChanged: (value){
                  enterPASSWORD = value;
                },
                obscureText: hidden_password,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  suffixIcon: GestureDetector(
                    onTap: (){
                      setState(() {
                        hidden_password = !hidden_password;
                      });
                    },
                  child: Icon(hidden_password ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                onChanged: (value){
                  enterNEW_PASSWORD = value;
                },
                decoration: InputDecoration(
                  hintText: 'New Password',
                  prefixIcon: Icon(Icons.lock_open_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                onChanged: (value){
                  enterCONFIRM_PASSWORD = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_clock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: () async {
                    if(enterEMP_CODE.isNotEmpty){
                      DocumentSnapshot variable =
                          await FirebaseFirestore.instance.collection('Employee_Details')
                          .doc(enterEMP_CODE).get();
                      if(variable.exists){
                        if(enterPASSWORD.isNotEmpty){
                          if(enterPASSWORD == variable['PASSWORD']){
                            if(enterNEW_PASSWORD.isNotEmpty){
                              if(enterCONFIRM_PASSWORD.isNotEmpty) {
                                  if(enterNEW_PASSWORD == enterCONFIRM_PASSWORD){
                                    //writing data to fire_store
                                    Map <String,dynamic> data = {"PASSWORD": enterCONFIRM_PASSWORD};
                                    FirebaseFirestore.instance.collection('Employee_Details').doc(enterEMP_CODE).update(data);
                                    Fluttertoast.showToast(msg: "Password changed Successfully", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                    Navigator.pushNamed(context, 'login');
                                  }else{
                                    Fluttertoast.showToast(msg: "Mismatch b/w New & Confirm password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                                  }
                                }else{
                                Fluttertoast.showToast(msg: "Enter Confirm Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                              }
                            }else{
                              Fluttertoast.showToast(msg: "Enter New Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                            }
                          }else{
                            Fluttertoast.showToast(msg: "Incorrect Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                          }
                        }else{
                          Fluttertoast.showToast(msg: "Enter Password", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                        }
                      }
                      else{
                        Fluttertoast.showToast(msg: "Invalid Employee Code", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                      }

                    }
                    else{
                      Fluttertoast.showToast(msg: "Enter Employee Code", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                  textStyle: TextStyle(fontSize: 20)),
                  child: Text('Save',
                    style: TextStyle(color: Colors.white,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),


    );
  }
}
