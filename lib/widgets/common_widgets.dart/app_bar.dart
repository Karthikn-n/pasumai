import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? needBack;
  final double? fontSize;
  final bool? centerTitle;
  final Builder? leadBuilder;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final double? leadingWidth;
  final FontWeight? fontWeight;
  final IconData? leading;
  final String? toolTip;
  const AppBarWidget({
    super.key, 
    required this.title, 
    this.leading,
    this.needBack, 
    this.toolTip,
    this.fontSize,
    this.leadingWidth,
    this.fontWeight,
    this.centerTitle,
    this.leadBuilder,
    this.onBack, 
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: needBack ?? false,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AppTextWidget(
          text: title, 
          fontSize: fontSize ?? 20, 
          fontWeight: fontWeight ?? FontWeight.w500
        ),
        leadingWidth: leadingWidth,
        centerTitle: centerTitle ?? true,
        leading: needBack != null && needBack! 
        ? IconButton(
          tooltip: leading == null ? "Navigate up" : toolTip ,
          onPressed: onBack,
          icon: Icon(leading ?? CupertinoIcons.chevron_back, size: 20,),
        )
        : Container(),
        actions: actions,
        bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.3),  // Choose your preferred underline color
            height: 1.0,         // Height of the underline
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}