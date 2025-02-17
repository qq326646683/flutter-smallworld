import 'package:flutter/material.dart';
import 'package:flutter_smallworld/common/utils/index.dart';
import 'package:flutter_smallworld/widget/index.dart';

class SMButtonWidget extends StatelessWidget {
  final double width;

  final double height;

  final String text;

  final List<Color> gradientColors;

  final SMTextStyle textStyle;

  final VoidCallback onPress;

  SMButtonWidget({
    Key key,
    this.width,
    this.height,
    @required this.text,
    this.textStyle,
    this.gradientColors,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onPress?.call();
      },
      child: Container(
        padding: SMCommonStyle.btnPadding,
        alignment: Alignment.center,
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: this.gradientColors ??
                    [SMColors.lightGolden, SMColors.darkGolden],
                tileMode: TileMode.repeated)),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              this.text,
              style: this.textStyle ?? SMTxtStyle.normalText,
            )
          ],
        ),
      ),
    );
    ;
  }
}
