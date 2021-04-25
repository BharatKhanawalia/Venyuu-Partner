import 'package:flutter/material.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final Color borderColor;
  final Color backgroundColor;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final bool obscureText;
  final Widget suffixIcon;
  final TextEditingController controller;

  const RoundedPasswordField({
    this.hintText,
    this.validator,
    this.borderColor,
    this.backgroundColor,
    this.onSaved,
    this.obscureText,
    this.suffixIcon,
    this.controller,
  });

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      width: size.width * 0.8,
      borderColor: widget.borderColor,
      backgroundColor: widget.backgroundColor,
      child: TextFormField(
        key: ValueKey('password'),
        controller: widget.controller,
        onSaved: widget.onSaved,
        validator: widget.validator,
        keyboardType: TextInputType.visiblePassword,
        obscureText: widget.obscureText,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
