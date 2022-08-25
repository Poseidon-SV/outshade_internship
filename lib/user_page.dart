import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  late String userName;
  late String userAge;
  late String userGender;

  UserPage(this.userName, this.userAge, this.userGender);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Name: '), Text(userName),],),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Age: '), Text(userAge),],),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Gender: '), Text(userGender),],),
          SizedBox(height: 10,),
          ElevatedButton(
              child: Text('Exit'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green),
              onPressed: () {Navigator.pop(context);}),
        ],),),
    );
  }
}


