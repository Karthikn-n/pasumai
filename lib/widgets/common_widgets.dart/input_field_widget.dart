import 'package:flutter/material.dart';


class TextFields extends StatelessWidget {
  final String? hintText;
  final bool isObseure;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final int? maxLine;
  final FocusNode? focusNode;
  final bool? readOnly;
  final Widget? label;
  final double? borderRadius;
  final double? maxHeight;
  final VoidCallback? onEditingComplete;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;
  final double? hintTextSize;
  final String? labelText;
  final String? initalValue;
  final TextEditingController? controller;
  const TextFields({
    super.key, 
    this.hintText, 
    this.contentPadding,
    this.controller, 
    required this.isObseure,
    this.suffixIcon,
    this.onTap,
    this.borderRadius,
    this.label,
    this.maxLine,
    this.maxHeight,
    this.hintTextSize,
    this.readOnly,
    this.onEditingComplete,
    this.focusNode,
    this.initalValue,
    this.labelText,
    this.onFieldSubmitted,
    this.onChanged, 
    this.prefixIcon,
    this.validator,
    this.keyboardType, 
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width > 600 ? size.width  : size.width,
        maxHeight: maxHeight ?? kToolbarHeight
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObseure,
        initialValue: initalValue,
        maxLines: maxLine,
        focusNode: focusNode,
        // expands: false,
        
        keyboardType: keyboardType,
        readOnly: readOnly ?? false,
        onTap: onTap,
        textInputAction: textInputAction,
        obscuringCharacter: '*',
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        validator: validator,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          contentPadding: contentPadding,
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(0.5)
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(0.5)
          ),
          suffixIcon: suffixIcon,
          suffixIconColor: const Color(0xFF656872).withOpacity(1.0),
          hintText: hintText,
          label: label,
          hintStyle: TextStyle(
            fontSize: hintTextSize ?? 14,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(1.0)
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(1.0)
            )
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(1.0),
            )
          ),
          // fillColor: const Color(0xFF656872).withOpacity(0.1),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: const BorderSide(
              color: Colors.redAccent
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(1.0)
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(1.0)
            )
          )
        ),
      
      ),
    );
    
  }
}
 
class InputField extends StatelessWidget{
  final TextEditingController controller;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? readOnly;
  final FocusNode? focusNode;
  final int? maxLines;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  const InputField({
    required this.controller,
    this.labelText,
    this.onTap,
    this.onEditingComplete,
    this.textInputAction,
    this.readOnly,
    this.maxLines,
    this.focusNode,
    this.suffixIcon,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      textInputAction: textInputAction,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      focusNode: focusNode,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        // isCollapsed: true,
        hintText: labelText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500
        ),
        floatingLabelStyle:  TextStyle(
          fontSize: 18,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600)
        )
      ),
    );
  }
}