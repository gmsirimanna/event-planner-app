import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText; // Label text above the field
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isShowBorder;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final IconData? suffixIconUrl;
  final Widget? prefixIconUrl;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final double radius;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    this.labelText,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.fillColor,
    this.capitalization = TextCapitalization.none,
    this.isShowBorder = true,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.isEnabled = true,
    this.radius = 8.0,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.isPassword ? _obscureText : false,
          maxLines: widget.maxLines,
          textInputAction: widget.inputAction,
          keyboardType: widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _errorText = null;
              } else {
                _errorText = widget.validator?.call(value);
              }
            });
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            filled: true,
            fillColor: widget.fillColor ?? const Color(0xFFFFF5F3),
            border: widget.isShowBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: (_errorText != null && (widget.controller?.text.isNotEmpty ?? false))
                          ? Colors.red
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            enabledBorder: widget.isShowBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: (_errorText != null && (widget.controller?.text.isNotEmpty ?? false))
                          ? Colors.red
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            focusedBorder: widget.isShowBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: (_errorText != null && (widget.controller?.text.isNotEmpty ?? false))
                          ? Colors.red
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  )
                : InputBorder.none,
            prefixIcon: widget.isShowPrefixIcon ? widget.prefixIconUrl : null,
            suffixIcon: widget.isShowSuffixIcon
                ? widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black45,
                        ),
                        onPressed: _toggle,
                      )
                    : widget.suffixIconUrl != null
                        ? Icon(widget.suffixIconUrl, color: Colors.black45)
                        : null
                : null,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
