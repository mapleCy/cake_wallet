import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  SelectButton({
    @required this.image,
    @required this.text,
    @required this.onTap,
    this.isSelected = false,
  });

  final Image image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
          ? Theme.of(context).accentTextTheme.subtitle.decorationColor
          : Theme.of(context).accentTextTheme.caption.color;
    final textColor = isSelected
          ? Theme.of(context).accentTextTheme.headline.decorationColor
          : Theme.of(context).primaryTextTheme.title.color;
    final arrowColor = isSelected
        ? Theme.of(context).accentTextTheme.headline.decorationColor
        : Theme.of(context).accentTextTheme.subhead.color;

    final selectArrowImage = Image.asset('assets/images/select_arrow.png',
          color: arrowColor);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.only(left: 30, right: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                image ?? Offstage(),
                Padding(
                  padding: image != null
                    ? EdgeInsets.only(left: 15)
                    : EdgeInsets.only(left: 0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor
                    ),
                  ),
                )
              ],
            ),
            selectArrowImage
          ],
        ),
      ),
    );
  }
}