import 'package:flutter/material.dart';
import 'package:cake_wallet/router.dart';
import 'package:cake_wallet/routes.dart';

void main() => runApp(CakeWalletApp());

class CakeWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Router.generateRoute,
      initialRoute: welcomeRoute,
    );
  }
}