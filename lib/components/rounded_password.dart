import 'package:flutter/material.dart';
import 'package:rmc_kit/components/text_field_container.dart';


class RoundedPassword extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  const RoundedPassword({
    Key key,
    this.onChanged,
    this.hintText = 'Password',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.blue,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}