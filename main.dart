import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hesap makinesi",
      home: uygulamaAdi(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class uygulamaAdi extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Basit hesap makinesi")),
      body: anaEkran(),
    );
  }
}

class anaEkran extends StatefulWidget {
  @override
  _anaEkranState createState() => _anaEkranState();
}

class _anaEkranState extends State<anaEkran> {
  String _expression = '';
  String _result = '';
  final TextEditingController _controller = TextEditingController();

  void _appendNumber(String number) {
  setState(() {
    if (_expression.isEmpty && (number == '+' || number == '-' || number == '*' || number == '/')) {
    } else if (_expression.isNotEmpty && (_expression[_expression.length - 1] == '+' || _expression[_expression.length - 1] == '-' || _expression[_expression.length - 1] == '*' || _expression[_expression.length - 1] == '/') && (number == '+' || number == '-' || number == '*' || number == '/')) {
    } else {
      _expression += number;
      _controller.text = _expression; 
    }
  });
}
  void _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      setState(() {
        _result = exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
      _controller.clear(); 
    });
  }

  void _undo() {
    setState(() {
      var currentText = _controller.text;
      if (currentText.isNotEmpty) {
        _expression = currentText.substring(0, currentText.length - 1);
        _controller.text = _expression;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  readOnly: true,
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  _result,
                  style: TextStyle(fontSize: 30.0),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('('),
              _buildButton(')'),
              _buildButton('C'),
              _buildButton('undo'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('C'),
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('='),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: MaterialButton(
          padding: EdgeInsets.all(24.0),
          color: Colors.black,
          onPressed: () {
            if (buttonText == 'C') {
              _clear();
            } else if (buttonText == '=') {
              _calculate();
            } else if (buttonText == 'undo') {
              _undo();
            } else {
              _appendNumber(buttonText);
            }
          },
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
