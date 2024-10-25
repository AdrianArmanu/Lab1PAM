import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoanCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({Key? key}) : super(key: key);

  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final TextEditingController _amountController = TextEditingController();
  double _months = 1;
  final TextEditingController _percentController = TextEditingController();
  double _monthlyPayment = 0;

  void _calculateLoan() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double percent = double.tryParse(_percentController.text) ?? 0;
    double monthlyRate = percent / 100 / 12;

    if (amount > 0 && _months > 0 && percent > 0) {
      double payment = (amount * monthlyRate * pow(1 + monthlyRate, _months)) /
          (pow(1 + monthlyRate, _months) - 1);
      setState(() {
        _monthlyPayment = payment;
      });
    } else {
      setState(() {
        _monthlyPayment = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                hintText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text('Enter number of months: ${_months.round()}'),
            Slider(
              value: _months,
              min: 1,
              max: 60,
              divisions: 59,
              label: _months.round().toString(),
              onChanged: (value) {
                setState(() {
                  _months = value;
                });
              },
            ),
            TextField(
              controller: _percentController,
              decoration: const InputDecoration(
                labelText: 'Enter % per month',
                hintText: 'Percent',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                children: [
                  const Text(
                    'You will pay the approximate amount monthly:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_monthlyPayment.toStringAsFixed(2)}€',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateLoan,
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}
