import 'dart:ffi';

import 'package:calculater/Screen/Button_value.dart';
import 'package:flutter/material.dart';

class Calulater extends StatefulWidget {
  const Calulater({super.key});

  @override
  State<Calulater> createState() => _CalulaterState();
}

class _CalulaterState extends State<Calulater> {
  String number1 = ""; //0-9
  String operand = ""; // + - * / 5
  String number2 = ""; //0-9

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '$number1$operand$number2'.isEmpty
                        ? "0"
                        : '$number1$operand$number2',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Divider(),
            Wrap(
              children: Btn.buttonValue
                  .map(
                    (value) => SizedBox(
                        width: value == Btn.n0
                            ? ScreenSize.width / 2
                            : (ScreenSize.width / 4),
                        height: ScreenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white24)),
        child: InkWell(
          onTap: () => onBtnTab(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.add,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black;
  }

  void onBtnTab(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertTopercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendvalue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
       result= num1 + num2;
        break;
      case Btn.subtract:
        result= num1 - num2;
        break;
      case Btn.multiply:
        result= num1 * num2;
        break;
      case Btn.divide:
        result= num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = result.toStringAsPrecision(3);
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void convertTopercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
//final res = number1 operand number2;
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void appendvalue(String value) {
    // if is operand and not
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
      //assign value to number1 variable
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && number1.isEmpty || number1 == Btn.n0) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && number2.isEmpty || number2 == Btn.n0) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }
}
