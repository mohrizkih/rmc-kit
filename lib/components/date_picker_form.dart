import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/constant/color.dart';
import 'text_field_container.dart';

class DatePickerForm extends StatelessWidget {
  final FormFieldSetter<String> onChanged;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator validator;
  final String initialValue;

  DatePickerForm({this.onChanged, this.onSaved, this.validator, this.initialValue});
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DateTimePicker(
        initialValue: initialValue,
        dateMask: 'd MMM, yyyy',
        fieldLabelText: 'Pilih Tanggal Lahir',
        firstDate: DateTime(1960),
        lastDate: DateTime.now(),
        icon: Icon(
          Icons.calendar_today,
          color: primaryColor,
        ),
        dateLabelText: 'Tanggal Lahir',
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
