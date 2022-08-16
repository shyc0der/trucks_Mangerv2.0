import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/pages/reports_page.dart';
import 'package:trucks_manager/src/ui/pages/users_page.dart';
import 'package:trucks_manager/src/ui/pages/work_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin{
  late final TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Truck Manager'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // reports page
         const ReportsPage(),

          // work page
          WorkPage(),

          // users page
          UsersPage(),

        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (int val){
          setState(() {
            _tabController.index = val;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.work_history_outlined), label: 'Work'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add_alt_1_outlined), label: 'Users'),
        ],
      ),
    );
  }
}

