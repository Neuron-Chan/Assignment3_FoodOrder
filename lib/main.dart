import 'package:flutter/material.dart';
import 'make_order_screen.dart';
import 'query_order_screen.dart';
import 'update_order_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/make-order': (context) => MakeOrderScreen(),
        '/query-order': (context) => QueryOrderScreen(),
        '/update-order': (context) => UpdateOrderScreen(orderId: -1), // Placeholder orderId for now
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Order App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/make-order');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60), // Increase button size
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Make Order"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/query-order');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60), // Increase button size
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Query Orders"),
            ),
          ],
        ),
      ),
    );
  }
}

