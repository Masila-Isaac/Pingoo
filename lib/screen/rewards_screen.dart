import 'package:flutter/material.dart';

class Prize_Screen extends StatelessWidget {
  const Prize_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prizes List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PrizeScreen(),
    );
  }
}

class Prize {
  final String name;
  final int pointsNeeded;
  //final String price;

  Prize({required this.name, required this.pointsNeeded});
}

class PrizeScreen extends StatelessWidget {
  final List<Prize> prizes = [
    Prize(name: 'Prize 1', pointsNeeded: 100),
    Prize(name: 'Prize 2', pointsNeeded: 200),
    Prize(name: 'Prize 3', pointsNeeded: 300),
    Prize(name: 'Prize 4', pointsNeeded: 400),
    Prize(name: 'Prize 5', pointsNeeded: 500),
    Prize(name: 'Prize 6', pointsNeeded: 600),
    //more prizes
  ];

  PrizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prizes List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: prizes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final prize = prizes[index];
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prize.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Points Needed: ${prize.pointsNeeded}'),
                    SizedBox(height: 4),
                    //Text('Price: ${prize.price}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
