import 'package:Remindify/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.maxLines,
    this.validator,
    this.hintText,
    this.focusNode,
    this.maxLength,
    this.onChanged,
    this.keyboardType,
    this.isCenterAligned = false,
    this.hideValidatorWidget = false,
    this.prefix,
    this.inputFormatters,
    this.fillColor,
    this.onTap,
    this.suffix,
  });

  final TextEditingController controller;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? hintText;
  final FocusNode? focusNode;
  final int? maxLength;
  final Function(String)? onChanged;
  final bool isCenterAligned;
  final TextInputType? keyboardType;
  final bool hideValidatorWidget;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      focusNode: focusNode,
      maxLength: maxLength,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: isCenterAligned ? TextAlign.center : TextAlign.start,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        // prefixIconColor: Theme.of(context).primaryColor,
        fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        hintText: hintText,
        counterText: '',
        errorStyle: hideValidatorWidget ? const TextStyle(fontSize: 0) : null,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).hintColor.withOpacity(0.25)),
      ),
    ).padYY(5);
  }
}
