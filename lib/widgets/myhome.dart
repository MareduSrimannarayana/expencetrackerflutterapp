import 'package:expenceapp/theme/themeprovider.dart';
import 'package:expenceapp/widgets/addpage.dart';
import 'package:expenceapp/widgets/expencelist.dart';
import 'package:expenceapp/widgets/statisticspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

final curinProvider = StateProvider<int>((ref) => 0); 

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
  
    super.initState();
    ref.read(themeProvider.notifier).initialize();

  }

  @override
  Widget build(BuildContext context) {
    final curin = ref.watch(curinProvider); 

    final List<Widget> _pages = [
      const ExpensesWidget(), 

      const StatisticsScreen(),
    ];

    void _onItemTapped(int index) {
      ref.read(curinProvider.notifier).state =
          index; // Update the current index
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            icon: const Icon(Icons.brightness_6),
          )
        ],
      ),
      body: _pages[curin], // Display the selected page
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => const AddPage()),
              )
              .then((_) => setState(() {})); // Refresh if needed
        },
        tooltip: 'Add Expense',
        label: const Text("Add New Expense"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
        currentIndex: curin,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
