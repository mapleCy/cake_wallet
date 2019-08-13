import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';

class SetupPinCode extends StatefulWidget {
  @override
  _SetupPinCodeState createState() => _SetupPinCodeState();
}

class _SetupPinCodeState extends PinCodeState {
  bool isEnteredOriginalPin() => !(_originalPin.length == 0);
  List<int> _originalPin = [];
  
  _SetupPinCodeState() {
    title = "Setup PIN";
  }

  @override
  void onPinCodeEntered(PinCodeState state) {
    if (!isEnteredOriginalPin()) {
      _originalPin = state.pin;
      state.title = 'Enter your PIN again';
      state.clear();
    } else {

      if (listEquals<int>(state.pin, _originalPin)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Your PIN has been set up successfully!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("PIN is incorrect"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
        _originalPin = [];
        state.title = 'Setup PIN';
        state.clear();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
          middle: Text('Setup PIN'),
          backgroundColor: Colors.white,
          border: null,
          trailing: FlatButton(
            onPressed: () { changePinLength(pinLength == PinCodeState.fourPinLength ? PinCodeState.sixPinLength : PinCodeState.fourPinLength); },
            child: Text(_changePinLengthText())
          ),
      ),
      backgroundColor: Colors.white,
      body: body(context)
    );
  }

  String _changePinLengthText() {
    return 'Use '
      + (pinLength == PinCodeState.fourPinLength ? '${PinCodeState.sixPinLength}' : '${PinCodeState.fourPinLength}')
      + '-digits PIN';
  }
}
