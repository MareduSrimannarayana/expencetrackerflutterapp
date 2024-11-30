import 'package:expenceapp/database.dart';
import 'package:expenceapp/widgets/statisticspage.dart';
import 'package:expenceapp/widgets/updatepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final expensesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await DataBaseService.instance.getExpenses(ref);
});

class ExpensesWidget extends ConsumerWidget {
  const ExpensesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsyncValue = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
      ),
      body: expensesAsyncValue.when(
        data: (expenses) {
      
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    ref
                        .read(udrop.notifier)
                        .update((state) => expense['DropDown'].toString());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => UpdateAddPage(
                              data: expense,
                            )));
                  },
                  title: Text("${expense['Title']} => ${expense['DropDown']}"),
                  subtitle:
                      Text(" ₹ ${expense['Amount']} \n ${expense['Date']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteExpense(ref, expense['ID']);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _deleteExpense(WidgetRef ref, int id) async {
    await DataBaseService.instance.deleteExpense(id);
    ref.refresh(expensesProvider);
    ref.refresh(stpro);
  }
}
