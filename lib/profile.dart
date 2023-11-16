import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(

          ),
        ),

      ),
      drawer: Drawer(
        backgroundColor: Colors.blueAccent,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.person, color: Colors.black, size: 50,),
                    ),
                  ],
                )
            ),
            ListTile(
              leading: Icon(Icons.collections_bookmark, color: Colors.black,),
              title: Text('Book lending',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.checklist_rtl, color: Colors.black,),
              title: Text('Book requests',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black,),
              title: Text('About app',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.black,),
              title: Text('Support',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.output, color: Colors.black,),
              title: Text('Log out',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
