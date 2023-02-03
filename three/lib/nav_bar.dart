import 'package:flutter/material.dart';
import 'package:three/change_password.dart';
import 'package:three/globar_variable.dart';
import 'package:three/food_count_list.dart';

class nav_bar extends StatelessWidget {
  const nav_bar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(global_EMP_NAME),
            accountEmail: Text(global_DEPARTMENT),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/myg.png', fit: BoxFit.cover,),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/v.jpeg",
                  ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushNamed(context, 'home'),
          ),
          ListTile(
            leading: Icon(Icons.qr_code),
            title: Text('QR Coupon Generator'),
            onTap: () => Navigator.pushNamed(context, 'qr_coupon'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Daily Food Count'),
            onTap: () => Navigator.pushNamed(context, 'food_count_list'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Change Password'),
            onTap: () => Navigator.pushNamed(context, 'change_password'),
          ),
          ListTile(
            leading: Icon(Icons.wallet),
            title: Text('Coupon'),
            onTap: () => Navigator.pushNamed(context, 'coupon'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rating'),
            onTap: () => Navigator.pushNamed(context, 'rating'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Rating_List'),
            onTap: () => Navigator.pushNamed(context, 'rating_list_view'),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_sharp),
            title: Text('Qr_test'),
            onTap: () => Navigator.pushNamed(context, 'qr_test'),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => Navigator.pushNamed(context, 'login'),
          ),
        ],
      ),
    );
  }
}


