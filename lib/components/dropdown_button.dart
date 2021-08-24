import 'package:flutter/material.dart';
import 'package:rmc_kit/components/text_field_container.dart';
import 'package:rmc_kit/constant/color.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> list;
  final Function onChanged;
  final String hint;
  final IconData icon;

  CustomDropDown({this.list, this.onChanged, this.hint, this.icon});
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DropdownButtonFormField(
        items: list.map((String cList) {
          return DropdownMenuItem(value: cList, child: Text(cList));
        }).toList(),
        onChanged: onChanged,
        hint: Text(hint),
        decoration: InputDecoration(
          icon: Icon(icon, color: primaryColor,)
        ),
        
      ),
    );
  }
}
