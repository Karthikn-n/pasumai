import 'package:flutter/material.dart';


class TextFields extends StatelessWidget {
  final String? hintText;
  final bool isObseure;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool? readOnly;
  final double? borderRadius;
  final VoidCallback? onEditingComplete;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final VoidCallback? onTap;
  final String? labelText;
  final String? initalValue;
  final TextEditingController? controller;
  const TextFields({
    super.key, 
    this.hintText, 
    this.controller, 
    required this.isObseure,
    this.suffixIcon,
    this.onTap,
    this.borderRadius,
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
        maxWidth: size.width > 600 ? size.width  : size.width
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObseure,
        initialValue: initalValue,
        focusNode: focusNode,
        keyboardType: keyboardType,
        readOnly: readOnly ?? false,
        onTap: onTap,
        textInputAction: textInputAction,
        obscuringCharacter: '*',
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        validator: validator,
        style: TextStyle(
          fontSize: 15,
          color: const Color(0xFF656872).withOpacity(1.0)
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(0.5)
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(0.5)
          ),
          suffixIcon: suffixIcon,
          suffixIconColor: const Color(0xFF656872).withOpacity(1.0),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color:Colors.grey.withOpacity(0.5)
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: const Color(0xFF656872).withOpacity(0.1)
            )
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: const Color(0xFF656872).withOpacity(0.1)
            )
          ),
          fillColor: const Color(0xFF656872).withOpacity(0.1),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: const BorderSide(
              color: Colors.redAccent
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: const Color(0xFF656872).withOpacity(0.1)
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: const Color(0xFF656872).withOpacity(0.0)
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
  final TextInputAction? textInputAction;
  const InputField({
    required this.controller,
    this.labelText,
    this.textInputAction,
    this.readOnly,
    this.suffixIcon,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      textInputAction: textInputAction,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        
        labelStyle: TextStyle(
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