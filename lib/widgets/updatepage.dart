import 'package:expenceapp/database.dart';
import 'package:expenceapp/widgets/expencelist.dart';
import 'package:expenceapp/widgets/statisticspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final udrop = StateProvider((ref) => "Food");

class UpdateAddPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const UpdateAddPage({super.key, required this.data});

  @override
  _UpdateAddPageState createState() => _UpdateAddPageState();
}

class _UpdateAddPageState extends ConsumerState<UpdateAddPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['Title']);
    _amountController =
        TextEditingController(text: widget.data['Amount'].toString());
    _dateController = TextEditingController(text: widget.data['Date']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DataBaseService _dataBaseInstance = DataBaseService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Update Expense")),
      body: Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Title', false),
              _buildTextField(_amountController, 'Amount', true),
              _buildDateField(_dateController, context),
              _buildCategoryDropdown(ref.watch(udrop)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final double? amount =
                        double.tryParse(_amountController.text);
                    if (amount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a valid amount")),
                      );
                      return;
                    }

                    final Map<String, dynamic> dataa = {
                      'dropdown': ref.watch(udrop),
                      'date': _dateController.text,
                      'amount': amount,
                      'title': _titleController.text,
                    };
                    await _dataBaseInstance.updateExpence(
                        widget.data['ID'], dataa);
                    ref.refresh(stpro);
                    ref.refresh(expensesProvider);

                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Update Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isAmount) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: TextFormField(
        controller: controller,
        keyboardType: isAmount ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          labelText: label,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Date (YYYY-MM-DD)',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2056),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(String category) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: DropdownButton<String>(
        value: category,
        isExpanded: true,
        items: ['Food', 'Travel', 'Entertainment'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(udrop.notifier).update((state) => newValue);
          }
        },
      ),
    );
  }
}
