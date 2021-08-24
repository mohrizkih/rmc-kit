import 'package:flutter/material.dart';
import 'package:rmc_kit/components/text_field_container.dart';
import 'package:rmc_kit/constant/color.dart';

class RoundedInput extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final String labelText;
  final String hintText;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final Function onTap;
  final bool obsecure;
  final bool readOnly;
  RoundedInput({
    Key key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.validator,
    this.icon = Icons.person,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.obsecure = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onSaved: onSaved,
        onTap: onTap,
        validator: validator,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // autofocus: true,
        cursorColor: primaryColor,
        obscureText: obsecure,
        readOnly: readOnly,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: primaryColor,
          ),
          hintStyle: TextStyle(color: Colors.black),
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
