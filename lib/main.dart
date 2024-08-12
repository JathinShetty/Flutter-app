import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'analytics.dart';
import 'profile.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routes: {
        '/analytics': (context) => AnalyticsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  List<Map<String, String>> expenses = [];
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    expenseController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void addExpense(String amount, String category) {
    setState(() {
      expenses.add({'amount': amount, 'category': category});
    });
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (currentPageIndex == 0) ...[
                SizedBox(height: 20.0),
                Container(
                  height: 350.0,
                  width: 399.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.tealAccent[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 100,
                        width: 390,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Category: ${expense['category']}, Expense: \$${expense['amount']}',
                                  style: TextStyle(fontSize: 20,fontFamily: 'Inconsolata'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_rounded, color: Colors.black),
                              onPressed: () {
                                deleteExpense(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
              ],
              Container(
                height: 300,
                child: buildPageContent(currentPageIndex),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: currentPageIndex == 0
          ? SizedBox(
        height: 75.0,
        width: 75.0,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: expenseController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Enter Expense Amount'),
                      ),
                      TextField(
                        controller: categoryController,
                        decoration: InputDecoration(labelText: 'Enter Expense Category'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          addExpense(expenseController.text, categoryController.text);
                          expenseController.clear();
                          categoryController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Add Expense'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          elevation: 20.0,
          highlightElevation: 20.0,
          backgroundColor: Colors.tealAccent,
          child: Icon(Icons.add),
        ),
      )
          : null,
      bottomNavigationBar: GNav(
        gap: 5.0,
        iconSize: 29.0,
        rippleColor: Colors.tealAccent,
        tabBackgroundColor: Colors.tealAccent.withOpacity(0.3),
        duration: Duration(milliseconds: 500),
        tabs: [
          GButton(
            icon: Icons.home_filled,
            text: 'Home',
            onPressed: () {
              setState(() {
                currentPageIndex = 0;
              });
            },
          ),
          GButton(
            icon: Icons.auto_graph_outlined,
            text: 'Analytics',
            onPressed: () {
              setState(() {
                currentPageIndex = 1;
              });
            },
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
            onPressed: () {
              setState(() {
                currentPageIndex = 2;
              });
            },
          ),
        ],
        selectedIndex: currentPageIndex,
      ),
    );
  }

  Widget buildPageContent(int index) {
    switch (index) {
      case 0:
        return Center(child: Text(''));
      case 1:
        return AnalyticsScreen();
      case 2:
        return ProfileScreen();
      default:
        return Center(child: Text('Page Not Found'));
    }
  }
}
