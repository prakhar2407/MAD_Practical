import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class EmiCalc extends StatefulWidget {
  const EmiCalc({Key? key}) : super(key: key);
  @override
  State<EmiCalc> createState() => _EmiCalcState();
}

class _EmiCalcState extends State<EmiCalc> {
  double currSliderVal = 10.0;
  double loanAmount = 0.0;
  double interestRate = 0.0;
  double emi = 0.0;
  double totalPayment = 0.0;
  late double monthlyPr;
  late double monthlyROI;
  TextEditingController tc1 = TextEditingController();
  TextEditingController tc2 = TextEditingController();
  Map<String, double> dataMap = {"": 0.0};

  _calcAll() {
    loanAmount = double.parse(tc1.text);
    interestRate = double.parse(tc2.text);
    monthlyPr = loanAmount / currSliderVal;
    monthlyROI = (loanAmount * (interestRate / 100)) / currSliderVal;
    emi = monthlyPr + monthlyROI;
    totalPayment = emi * currSliderVal;
    setState(() {});
  }

  _getAppBar() {
    return AppBar(
      backgroundColor: Colors.amberAccent,
      title: const Text("EMI Calculator"),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.calculate,
            color: Colors.white,
          ),
          onPressed: () {
            dataMap.clear();
            dataMap.addAll({"EMI": emi, "Total Payment": totalPayment});
            _calcAll();
          },
        )
      ],
    );
  }

  _getDetails() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          _getTextField(
              textFieldValue: loanAmount,
              tc: tc1,
              helpText: "Enter the Principal Amount",
              message: "Enter Loan amount",
              iconName: Icons.attach_money),
          SizedBox(
            height: 20,
          ),
          _getTextField(
              textFieldValue: interestRate,
              tc: tc2,
              helpText: "Enter the Interest Rate 0% - 100%",
              message: "Enter Interest rate",
              iconName: Icons.money),
          SizedBox(
            height: 20,
          ),
          _getSlider(),
          SizedBox(
            height: 20,
          ),
          _getEmi(),
          SizedBox(
            height: 20,
          ),
          _getPieChart()
        ],
      ),
    );
  }

  _getSlider() {
    return Row(
      children: [
        Expanded(
            child: Column(children: [
          Center(
              child: Text(
            "Tenure Value: $currSliderVal",
            style:
                TextStyle(fontWeight: FontWeight.w900, color: Colors.redAccent),
          ))
        ])),
        Expanded(
          child: Column(
            children: [
              Slider.adaptive(
                value: currSliderVal,
                max: 60,
                divisions: 6,
                label: currSliderVal.round().toString(),
                onChanged: (double val) {
                  currSliderVal = val;
                  setState(() {});
                },
              )
            ],
          ),
        )
      ],
    );
  }

  _getEmi() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        "EMI: $emi",
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    ]);
  }

  _getPieChart() {
    return PieChart(
      dataMap: dataMap,
    );
  }

  _getTextField(
      {required double textFieldValue,
      required TextEditingController tc,
      required String helpText,
      String message = "Enter Value",
      required IconData iconName}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: tc,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text(message),
              prefixIcon: Icon(iconName),
              // helperText: helpText,
              suffixText: tc.text,
              // hintText: message,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _getAppBar(),
        body: SingleChildScrollView(child: Column(children: [_getDetails()])),
      ),
    );
  }
}