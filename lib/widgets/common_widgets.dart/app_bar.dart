import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? needBack;
  final Builder? leadBuilder;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final IconData? leading;
  const AppBarWidget({
    super.key, 
    required this.title, 
    this.leading,
    this.needBack, 
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AppTextWidget(
          text: title, 
          fontSize: 16, 
          fontWeight: FontWeight.w400
        ),
        centerTitle: true,
        leading: needBack != null && needBack! 
        ? IconButton(
          onPressed: onBack,
          icon: Icon(leading ?? CupertinoIcons.chevron_back, size: 20,),
        )
        : Container(),
        actions: actions,
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}