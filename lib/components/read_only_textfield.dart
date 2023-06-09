import 'package:flutter/material.dart';

class ReadOnlyTextField extends StatelessWidget {
  final String label;
  final String defaultText;
  final bool enable;

  ReadOnlyTextField({super.key, required this.label, required this.defaultText, this.enable=true});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: defaultText);

    return TextField(
      controller: controller,
      enabled: enable,
       style: TextStyle(
                 color: Colors.white,
              ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      
         border: OutlineInputBorder(
          borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    ),
      ),
    );
  }
}
