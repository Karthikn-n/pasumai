import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RaiseAQueryWidget extends StatefulWidget {
  const RaiseAQueryWidget({super.key});

  @override
  State<RaiseAQueryWidget> createState() => _RaiseAQueryWidgetState();
}

class _RaiseAQueryWidgetState extends State<RaiseAQueryWidget> {
  TextEditingController queryController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool needQuery = false;

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: "Raise a Query",
        needBack: true,
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Consumer<ProfileProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextWidget(
                        text: "Select query", 
                        fontSize: 18, 
                        fontWeight: FontWeight.w500
                      ),
                      needQuery 
                        ? const AppTextWidget(text: "* query required", fontSize: 12, fontWeight: FontWeight.w400, fontColor: Colors.red,) 
                        : Container()
                    ],
                  ),
                  const SizedBox(height: 12,),
                  ...List.generate(provider.queryOptions.length, 
                    (index) {
                      return SizedBox(
                        height: kToolbarHeight - 5,
                        child: ListTile(
                          // tileColor: provider.selectedQuery == provider.queryOptions[index]
                          //   ? Theme.of(context).primaryColor
                          //   : null,
                          title: AppTextWidget(
                            fontSize: 14,
                            
                            text: provider.queryOptions[index], 
                            fontWeight: FontWeight.w400
                          ),
                          trailing: provider.selectedQuery == provider.queryOptions[index]
                            ? Icon(CupertinoIcons.check_mark_circled, size: 20, color: Theme.of(context).primaryColor,)
                            : null,
                          onTap: () {
                            provider.selectQuery(index);
                            setState(() {
                              needQuery = false;
                            });
                          },
                        )
                        // RadioListTile<String>(
                        //   toggleable: true,
                        //   contentPadding: EdgeInsets.zero,
                        //   value: provider.queryOptions[index], 
                        //   groupValue: provider.selectedQuery, 
                        //   onChanged: (value) {
                        //     provider.selectQuery(index);
                        //     setState(() {
                        //       needQuery = false;
                        //     });
                        //   },
                        //   title: AppTextWidget(
                        //     text: provider.queryOptions[index], 
                        //     fontSize: 14, 
                        //     fontWeight: FontWeight.w400
                        //   ),
                        // ),
                      );
                    },
                  ),
                  const SizedBox(height: 16,),
                  const AppTextWidget(
                    text: "More about query", 
                    fontSize: 16, 
                    fontWeight: FontWeight.w500
                  ),
                  const SizedBox(height: 12,),
                  Form(
                    key: formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: SizedBox(
                        height: kToolbarHeight,
                        child: TextFields(
                          controller: queryController,
                          maxLine: 10,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          hintText: provider.selectedQuery ?? "Enter query",
                          isObseure: false,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Comments is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: ButtonWidget(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      width: double.infinity,
                      buttonName: "Raise a query", 
                      onPressed: () async {
                        print(provider.selectedQuery);
                        if (provider.selectedQuery == null) {
                          setState(() {
                            needQuery = true;
                          });
                        }
                        if (formkey.currentState!.validate()) {
                          await provider.raiseAQueryAPI(queryController.text, size, context);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}