import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Constants.dart';

showSnackBar({required title,required message,Duration? duration,position: SnackPosition.BOTTOM}) 
{
  double bottomPadding = position == SnackPosition.BOTTOM
      ? kBottomNavigationBarHeight + 40.0 // Add some extra spacing
      : 0.0;
  Get.snackbar(title, message,
      backgroundColor: (title == 'error') ? Colors.redAccent : greyColor,
      colorText: textColor,

      snackPosition: position,
      margin: EdgeInsets.fromLTRB(
          10, 10, 10, bottomPadding), // Add padding at the bottom
      duration: duration ?? const Duration(seconds: 2));
}

snackBarText({required title,required message}){
  return SnackBar(

    content: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          height: 60,
          decoration: BoxDecoration(
            color: (title == 'error') ? redColor : Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Row(
            children: [
              SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start ,
                  children: [
                    
                    Text('$message', style: TextStyle(color: textColor, fontSize: 16),maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

Widget textView(String text,
    {double fontSize = 14,
    var color = Colors.black87,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Alignment alignment = Alignment.centerLeft,
    int maxLines = 2,
    bool multiLine = true,
    var textOverflow = TextOverflow.ellipsis,
    var textAlign = TextAlign.left,
    var textDirection = TextDirection.ltr,
    var height = 1.2,
    var wordSpacing = 1.0,
    var letterSpacing = 1.0,
    bool needLineThrough = false,
    bool needUnderLine = false,
    needFancyFont = false}) {
  return Align(
    alignment: alignment,
    child: Text(
      text,
      style: needFancyFont
          ? GoogleFonts.fjallaOne(
              decoration: needLineThrough
                  ? TextDecoration.lineThrough
                  : needUnderLine
                      ? TextDecoration.underline
                      : TextDecoration.none,
              color: color,
              wordSpacing: wordSpacing,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontSize: fontSize,
              fontStyle: fontStyle,
              height: height)
          : GoogleFonts.fjallaOne(
              decoration: needLineThrough
                  ? TextDecoration.lineThrough
                  : needUnderLine
                      ? TextDecoration.underline
                      : TextDecoration.none,
              color: color,
              fontWeight: fontWeight,
              fontSize: fontSize,
              height: height),
      overflow: textOverflow,
      maxLines: maxLines == 0 ? null : maxLines,
//softWrap: true,
      textAlign: textAlign,
      textDirection: textDirection,
    ),
  );
}

vSpace(height) {
  return SizedBox(
    height: height.toDouble(),
  );
}

hSpace(width) {
  return SizedBox(
    width: width.toDouble(),
  );
}

// ignore: non_constant_identifier_names
BigText(text, [color = Colors.white, size, overFlow = TextOverflow.ellipsis]) {
  return Text(
    text,
    overflow: overFlow,
    style: GoogleFonts.laila(
          fontWeight: FontWeight.w400,
        fontSize: size == 0.0 ? Dimensions.font17 : size,
        color: textColor
        ),
        
        
  );
}

SmallText(text,
    [color = Colors.white, size = 15.0, overFlow = TextOverflow.ellipsis]) {
  return Text(
    text,
    overflow: overFlow,
    style: TextStyle(
        color: color, fontWeight: FontWeight.w400, fontSize: size, height: 1.2),
  );
}

IconText(icon, iconColor, text, text_color) {
  return Row(
    children: [
      Icon(
        icon,
        color: iconColor,
        size: Dimensions.iconSize24,
      ),
      SizedBox(
        width: Dimensions.width10,
      ),
      SmallText(text, text_color)
    ],
  );
}



Widget button(
    {required dynamic child,
    Color color = Constants.colorPrimary,
    double height = 50.0,
    double width = double.infinity,
    IconData? icon,
    VoidCallback? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
          child: child is String
              ? icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(icon, color: Constants.colorLight, size: 16),
                          Constants.horizontalSpace,
                          Expanded(
                            child: Text(child,
                                style: TextStyle(
                                  color: color == Constants.colorWarning
                                      ? mainColor
                                      : textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.visible),
                          )
                        ],
                      ),
                    )
                  : Text(
                      child,
                      style:  TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
              : child),
    ),
  );
}
