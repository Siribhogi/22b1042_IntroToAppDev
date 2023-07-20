import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: BudgetTracker(),
    ));

class Expense {
  String category;
  int amount;

  Expense({required this.category, required this.amount});
}

class BudgetTracker extends StatefulWidget {
  @override
  State<BudgetTracker> createState() => _BudgetTrackerState();
}

class _BudgetTrackerState extends State<BudgetTracker> {

  int TotalAmount=0;
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  List<Expense> expenses = [];
  bool showCategories = false;


  void deleteExpense(int index) {
    setState(() {
      TotalAmount -= expenses[index].amount;
      expenses.removeAt(index);
    });
  }

  void toggleCategoriesVisibility() {
    setState(() {
      showCategories = !showCategories;
    });
  }

  void AddExpense(){
    _categoryController.clear();
    _amountController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[900],
          title: Center(
            child: Text('New Entry',
            style: TextStyle(
                fontSize: 30,
              color: Colors.white60,
            ),),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category:',
                  labelStyle: TextStyle(decoration: TextDecoration.none,
                    fontSize: 25,
                    color: Colors.white60,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Price:',
                  labelStyle: TextStyle(decoration: TextDecoration.none,
                    fontSize: 25,
                    color: Colors.white60,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            FloatingActionButton(
              onPressed: () {
                int amount = int.tryParse(_amountController.text) ?? 0;
                String category = _categoryController.text.trim();
                if (category.isNotEmpty && amount!=0) {
                  setState(() {
                    TotalAmount += amount;
                    expenses.add(Expense(
                      category: _categoryController.text,
                      amount: amount,
                    ));
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
                else if(category.isEmpty && amount==0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter a valid Category and Amount.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                else if(amount==0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter a valid Amount.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                else if(category.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter a valid Category.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                };
              },
              child: Icon(Icons.check_circle_outline,
              size: 50,),
              elevation: 0,
              backgroundColor: Colors.deepPurple[900],
              foregroundColor: Colors.white54,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepPurple[300],
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
              child: Container(
                width: 365,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                        'Total:             ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),),
                    Text(
                      '${TotalAmount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),),
                    Expanded(
                      child: Container(
                        child:FloatingActionButton.small(
                          child: Icon(Icons.keyboard_double_arrow_down_rounded),
                          onPressed: () =>toggleCategoriesVisibility(),
                          elevation: 0,
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.black38,width: 3),
                          ),
                          foregroundColor: Colors.black54,
                          backgroundColor: Colors.deepPurple[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height:40,
            ),
            Visibility(
              visible: showCategories,
              child: Expanded(
                child: ListView(
                  children: expenses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final expense = entry.value;
                    return Row(
                        children:[
                          Expanded(
                       child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 10),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Text(expense.category,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[300],
                            ),),
                            Spacer(),
                            Text(
                              '${expense.amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                          ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: FloatingActionButton(
                                onPressed: () => deleteExpense(index),
                                child: Icon(Icons.delete,
                                size: 30,),
                                backgroundColor: Colors.black,
                               foregroundColor: Colors.deepPurple[300],
                               elevation: 0,
                              ),
                           ),
                        ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: AddExpense,
        foregroundColor: Colors.deepPurple[500],
        backgroundColor: Colors.deepPurple[100],
      ),
    );
  }
}

