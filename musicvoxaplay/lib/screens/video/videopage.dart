import 'package:flutter/material.dart';
import 'package:musicvoxaplay/screens/widgets/appbar.dart';
import 'package:musicvoxaplay/screens/widgets/bottom_navigationbar.dart';


class Videopage extends StatefulWidget {
  const Videopage({super.key});

  @override
  _VideopageState createState() => _VideopageState();
}

class _VideopageState extends State<Videopage> {
  int _currentIndex = 1; 

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context, 'All videos', showBackButton: true),
   
      body:  Center(
        child: Text('videos not found',
           style: Theme.of(context).textTheme.bodyLarge,),
      ),

      
      bottomNavigationBar: buildBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        context: context, 
      ),
    );
  }
}


