import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';

class FavCheck extends StatefulWidget {
  const FavCheck({
    Key? key,
    this.radius = 13,
  }) : super(key: key);
  final double radius;
  @override
  State<FavCheck> createState() => _FavCheckState();
}

class _FavCheckState extends State<FavCheck> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
        scale: 1.5,
        child: Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: const CircleBorder(),
              checkColor: MaterialStateProperty.all<Color>(textColor),
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return greyColor8;
                  } else {
                    return greyColor;
                  }
                },
              ),
              splashRadius: 10.0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              tristate: false,
              value: value,
              onChanged: (bool? newValue) {
                setState(() {
                  value = newValue ?? false;
                  if (value) {
                    // addItemToCart();
                  }
                });
              }),
        ),
      ),
    );
  }
}
