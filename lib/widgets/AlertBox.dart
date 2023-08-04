import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Constants.dart';

enum AlertType { success, info, warning, danger }

class AlertBox {
  final String title;
  final String? message;
  AlertType? alertType = AlertType.success;
  final Color? messageTextColor;
  final Color? buttonColorForYes;
  final Color? buttonTextColorForYes;
  final String? buttonTextForYes;
  final Color? buttonColorForNo;
  final Color? buttonTextColorForNo;
  final String? buttonTextForNo;
  final VoidCallback? onPressedYes;
  final VoidCallback? onPressedNo;

  AlertBox(
      {required this.title,
      this.message,
      this.alertType,
      this.messageTextColor,
      this.buttonColorForYes,
      this.buttonTextForYes,
      this.buttonTextColorForYes,
      this.buttonColorForNo,
      this.buttonTextColorForNo,
      this.buttonTextForNo,
      this.onPressedYes,
      this.onPressedNo}) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          Color color = Constants.colorInfo;
          IconData iconData = Icons.info;
          switch (alertType) {
            case AlertType.info:
              color = Constants.colorInfo;
              iconData = Icons.info_outline_rounded;
              break;
            case AlertType.warning:
              color = Constants.colorWarning;
              iconData = Icons.warning_amber;
              break;
            case AlertType.danger:
              color = Constants.colorDanger;
              iconData = Icons.dangerous_outlined;
              break;
            case AlertType.success:
            default:
              color = Colors.green;
              iconData = Icons.task_alt_outlined;
              break;
          }
          return SimpleDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  iconData,
                  color: color,
                ),
                Constants.horizontalSpace,
                Flexible(
                  child: Text(
                    title,
                    style:  TextStyle(fontWeight: FontWeight.w600, color: mainColor),
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            children: <Widget>[
              Text(
                message ?? "",
                style:  TextStyle(color: mainColor),
              ),
              Constants.verticalSpaceL,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColorForNo ?? greyColor),
                    ),
                    onPressed: onPressedNo ?? () => Get.back(),
                    child: Text(
                      buttonTextForNo ?? 'Close',
                      style: TextStyle(color: buttonTextColorForNo ?? textColor),
                    ),
                  ),
                  Constants.horizontalSpace,
                  onPressedYes != null
                      ? TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonColorForYes ?? mainColor),
                          ),
                          onPressed: onPressedYes ?? () {},
                          child: Text(
                            buttonTextForYes ?? "Yes",
                            style: TextStyle(color: buttonTextColorForYes ?? textColor),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          );
        });
  }
}
