import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/transaction_direction.dart';


class TransactionRow extends StatelessWidget {
  final VoidCallback onTap;
  final TransactionDirection direction;
  final String formattedDate;
  final String formattedAmount;
  final String formattedFiatAmount;

  TransactionRow(
      {this.direction,
      this.formattedDate,
      this.formattedAmount,
      this.formattedFiatAmount,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _isDarkTheme = false;

    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: PaletteDark.darkGrey,
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(children: <Widget>[
            Image.asset(
                direction == TransactionDirection.incoming
                    ? 'assets/images/transaction_incoming.png'
                    : 'assets/images/transaction_outgoing.png',
                height: 25,
                width: 25),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            direction == TransactionDirection.incoming
                                ? 'Received'
                                : 'Sent',
                            style: TextStyle(
                                fontSize: 16,
                                color: _isDarkTheme
                                    ? Palette.blueGrey
                                    : Colors.black)),
                        Text(formattedAmount,
                            style: const TextStyle(
                                fontSize: 16, color: Palette.purpleBlue))
                      ]),
                  SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 13, color: Palette.blueGrey)),
                        Text(formattedFiatAmount,
                            style: const TextStyle(
                                fontSize: 14, color: Palette.blueGrey))
                      ]),
                ],
              ),
            ))
          ]),
        ));
  }
}
