import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Interest Calculator App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,

        //primarySwatch: Colors.lightGreen,
      ),
      home: SIForm(),
    );
  }
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();

  final double _minimumPadding = 5.0;

  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String result = "";

  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  var _currentItemSelected;

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
   // TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle textStyle = TextStyle(
      fontStyle : FontStyle.italic,
      color: Colors.white,
      fontSize: 20.0
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Interest Calculator App'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              getImage(),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: principalController,
                    decoration: InputDecoration(
                        labelText: "Principal",
                        hintText: "Enter Principal e.g. 12000",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: getValidator("principal amount"),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: rateController,
                    decoration: InputDecoration(
                        labelText: "Rate of Interest",
                        hintText: "In Percent",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: getValidator("rate of interest"),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      style: textStyle,
                      keyboardType: TextInputType.number,
                      controller: termController,
                      decoration: InputDecoration(
                          labelText: "Term",
                          hintText: "Time in years",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: getValidator("time"),
                    )),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                      items: _currencies.map((String dropDownItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownItem,
                          child: Text(dropDownItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        _dropDownItemSelected(newValueSelected);
                      },
                      value: _currentItemSelected,
                    )),
                  ])),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          "Calculate",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              this.result = _calculateTotalReturns();
                            }
                          });
                        },
                      )),
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text("Reset", textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            _resetValues();
                          });
                        },
                      )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: Text(this.result, style: textStyle),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  Widget getImage() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(rateController.text);
    double term = double.parse(termController.text);
    double totalAmountPayable = principal + (principal * rate * term) / 100;

    return "After $term years, your investment will be worth $totalAmountPayable "
        "$_currentItemSelected";
  }

  void _resetValues() {
    principalController.text = "";
    rateController.text = "";
    termController.text = "";
    result = "";
    _currentItemSelected = _currencies[0];
  }

  static bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  FormFieldValidator<String> getValidator(String fieldName) {
    return (String value) {
      if (value.isEmpty) {
        return 'Please enter $fieldName';
      }
      if (!isNumeric(value)) {
        return 'Please enter a number';
      }
      if (double.parse(value) <= 0) {
        return 'Above zero please';
      }
    };
  }
}
