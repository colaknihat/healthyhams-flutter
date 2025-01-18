import 'package:flutter/material.dart';
import 'package:healthyhams/ui/calendar.dart';
import 'package:healthyhams/ui/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      //THEME
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(158, 223, 156, 1)),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const MyHomePage(title: '',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final screns = [
    const ProfileScreen(),
    const CalendarWidget(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(

          iconSize: 40,
          selectedIconTheme: const IconThemeData(
            color: Color.fromRGBO(158, 223, 156, 1),
          ),
          unselectedIconTheme: const IconThemeData(
            color: Color.fromRGBO(31, 69, 71, 1),
          ),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              label: "Today",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.stacked_line_chart_rounded
                ),
              ),
            ),
      
            BottomNavigationBarItem(
              label: "Calendar",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.calendar_month
                ),
              ),
            ),

            /*BottomNavigationBarItem(
              label: "Calendar",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.assignment_ind
                ),
              ),
            ),*/
      
           /*  BottomNavigationBarItem(
              label: "Profile",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.person
                ),
              ),
            ), */
            
          ],
        ),
        //Add a label style here TOO ADD! 
        ),
      
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Center(child: Text("healthyhams")),
      ),
      body: screns[_currentIndex],


       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
