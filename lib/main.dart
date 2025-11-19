import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: const Color(0xFF2D3142),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _num1 = 0;
  double _num2 = 0;
  String _operation = '';
  bool _shouldResetDisplay = false;
  String _currentExpression = '';
  String _fullExpression = '';
  List<String> _history = [];

  // Hàm tính toán
  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) return double.nan;
        return a / b;
      default:
        return a;
    }
  }

  void _onButtonPressed(String value) {
    setState(() {
      // Number buttons
      if (RegExp(r'^[0-9]$').hasMatch(value)) {
        if (_display == '0' || _shouldResetDisplay) {
          _display = value;
          _shouldResetDisplay = false;
          if (_operation.isNotEmpty) {
            _currentExpression = '$_num1 $_operation $_display';
          } else {
            _currentExpression = _display;
          }
        } else {
          _display += value;
          if (_operation.isNotEmpty) {
            _currentExpression = '$_num1 $_operation $_display';
          } else {
            _currentExpression = _display;
          }
        }
        return;
      }

      // Decimal
      if (value == '.') {
        if (_shouldResetDisplay) {
          _display = '0.';
          _shouldResetDisplay = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        if (_operation.isNotEmpty) {
          _currentExpression = '$_num1 $_operation $_display';
        } else {
          _currentExpression = _display;
        }
        return;
      }

      // Clear All
      if (value == 'C') {
        _display = '0';
        _num1 = 0;
        _num2 = 0;
        _operation = '';
        _shouldResetDisplay = false;
        _currentExpression = '';
        _fullExpression = '';
        _history.clear();
        return;
      }

      // CE: xóa 1 ký tự
      if (value == 'CE') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
        if (_operation.isNotEmpty) {
          _currentExpression = '$_num1 $_operation $_display';
        } else {
          _currentExpression = _display;
        }
        return;
      }

      // Change sign
      if (value == '±') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else if (_display != '0') {
          _display = '-$_display';
        }
        if (_operation.isNotEmpty) {
          _currentExpression = '$_num1 $_operation $_display';
        } else {
          _currentExpression = _display;
        }
        return;
      }

      // Percentage
      if (value == '%') {
        _display = (double.parse(_display) / 100).toString();
        if (_operation.isNotEmpty) {
          _currentExpression = '$_num1 $_operation $_display';
        } else {
          _currentExpression = _display;
        }
        return;
      }

      // Operation buttons - TÍNH LIÊN TỤC
      if (['+', '-', '×', '÷'].contains(value)) {
        _num2 = double.parse(_display);

        if (_operation.isNotEmpty) {
          double result = _calculate(_num1, _num2, _operation);

          if (result.isNaN) {
            _display = "Error";
            _operation = '';
            _num1 = 0;
            _currentExpression = '';
            _fullExpression = '';
            return;
          }

          // Xây dựng chuỗi phép tính đầy đủ
          if (_fullExpression.isEmpty) {
            _fullExpression = '$_num1 $_operation $_num2';
          } else {
            _fullExpression += ' $_operation $_num2';
          }

          _display = result.toString();
          _num1 = result;
          _currentExpression = '$result $value';
        } else {
          _num1 = _num2;
          _currentExpression = '$_num1 $value';
          _fullExpression = '$_num1';
        }

        _operation = value;
        _shouldResetDisplay = true;
        return;
      }

      // Equals
      if (value == '=') {
        if (_operation.isEmpty) return;

        _num2 = double.parse(_display);

        double result = _calculate(_num1, _num2, _operation);

        if (result.isNaN) {
          _display = "Error";
          _operation = '';
          _num1 = 0;
          _currentExpression = '';
          _fullExpression = '';
          return;
        }

        // Hoàn thiện chuỗi phép tính
        if (_fullExpression.isEmpty) {
          _fullExpression = '$_num1 $_operation $_num2';
        } else {
          _fullExpression += ' $_operation $_num2';
        }

        // Lưu toàn bộ chuỗi phép tính vào lịch sử
        _history.insert(0, '$_fullExpression = $result');

        _display = result.toString();
        _num1 = result;
        _operation = '';
        _currentExpression = '';
        _fullExpression = '';
        _shouldResetDisplay = true;
      }
    });
  }

  Widget buildButton(String text, {Color color = const Color(0xFF4F5D75)}) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _onButtonPressed(text),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HISTORY DISPLAY
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF4F5D75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentExpression.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _currentExpression,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView(
                        children: _history
                            .map(
                              (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // RESULT DISPLAY
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // BUTTON AREA
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildButton("C", color: Colors.red)),
                          Expanded(child: buildButton("CE")),
                          Expanded(child: buildButton("%")),
                          Expanded(child: buildButton("÷", color: Colors.orange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildButton("7")),
                          Expanded(child: buildButton("8")),
                          Expanded(child: buildButton("9")),
                          Expanded(child: buildButton("×", color: Colors.orange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildButton("4")),
                          Expanded(child: buildButton("5")),
                          Expanded(child: buildButton("6")),
                          Expanded(child: buildButton("-", color: Colors.orange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildButton("1")),
                          Expanded(child: buildButton("2")),
                          Expanded(child: buildButton("3")),
                          Expanded(child: buildButton("+", color: Colors.orange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildButton("±")),
                          Expanded(child: buildButton("0")),
                          Expanded(child: buildButton(".")),
                          Expanded(child: buildButton("=", color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}