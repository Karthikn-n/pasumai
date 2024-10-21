import 'package:app_3/data/constants.dart';
import 'package:app_3/model/vacation_model.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/providers/vacation_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/button_widget.dart';
import 'package:app_3/widgets/shimmer_widgets/shimmer_profile_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/snackbar_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VacationListWidget extends StatelessWidget {
  const VacationListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return provider.vacations.isEmpty
          ? FutureBuilder(
              future: provider.vacationList(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                            text: "Vacation mode", 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500
                          ),
                          SizedBox(height: 15,),
                          Expanded(child: ShimmerProfileWidget())
                        ],
                      ),
                    ),
                  );
                }else if(!snapshot.hasData || snapshot.hasError){
                  return Center(
                    child: Column(
                      children: [
                        const AppTextWidget(
                          text: "You have no vacations",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 40,),
                        Consumer<VacationProvider>(
                          builder: (context, vacation, child) {
                            return TextButton(
                              onPressed: () async {
                                print(DateTime.now().hour);
                              if (DateTime.now().hour >= 15 ) {
                                final alertMessage = snackBarMessage(
                                  context: context, 
                                  message: "You can't add vacation after 3PM", 
                                  backgroundColor: Theme.of(context).primaryColor, 
                                  sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05);
                                ScaffoldMessenger.of(context).showSnackBar(alertMessage);
                              }else{
                                vacation.validate(false);
                                vacation.clearAddDates();
                                addVacation(context: context, size: size, isUpdating: false);
                              }
                              },
                              child: AppTextWidget(
                                text: "Add vacation", 
                                fontSize: 14, 
                                fontColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500
                              ), 
                            );
                          }
                        )
                      ],
                    ),
                  );
                } else{
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppTextWidget(
                              text: "Vacation mode", 
                              fontSize: 16, 
                              fontWeight: FontWeight.w500
                            ),
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  tooltip: "Add vacation",
                                  onPressed: (){
                                    if (DateTime.now().hour >= 15 ) {
                                      final alertMessage = snackBarMessage(
                                        context: context, 
                                        message: "You can't add vacation after 3PM", 
                                        backgroundColor: Theme.of(context).primaryColor, 
                                        sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05);
                                      ScaffoldMessenger.of(context).showSnackBar(alertMessage);
                                    }else{
                                      addVacation(context: context, size: size, isUpdating: false);
                                    }
                                  }, 
                                  icon: Icon(CupertinoIcons.plus, size: 20, color: Theme.of(context).primaryColor,)
                                );
                              }
                            )
                          ],
                        ),
                        Expanded(
                          child: vacationList(size)
                        )
                      ],
                    ),
                  );
                }
              },
            )
          : Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextWidget(
                          text: "Vacation mode", 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        ),
                        Consumer<VacationProvider>(
                          builder: (context, vacation, child) {
                            return IconButton(
                              tooltip: "Add vacation",
                              onPressed: (){
                                if (DateTime.now().hour >= 15 ) {
                                  final alertMessage = snackBarMessage(
                                    context: context, 
                                    message: "You can't add vacation after 3PM", 
                                    backgroundColor: Theme.of(context).primaryColor, 
                                    sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05);
                                  ScaffoldMessenger.of(context).showSnackBar(alertMessage);
                                }else{
                                  vacation.validate(false);
                                  vacation.clearAddDates();
                                  addVacation(context: context, size: size, isUpdating: false);
                                }
                              }, 
                              icon: Icon(CupertinoIcons.plus, size: 20, color: Theme.of(context).primaryColor,)
                            );
                          }
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: vacationList(size)
                  )
                ],
              ),
            );
              
      },
    );
  }

  // List of vacations
  Widget vacationList(Size size){
    return Consumer3<ProfileProvider, VacationProvider, Constants >(
      builder: (context, provider, vacation, scrollController, child) {
        List<VacationsModel> vacations = provider.vacations.reversed.toList();
        return CupertinoScrollbar(
          controller: scrollController.vacationScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              controller: scrollController.vacationScrollController,
              itemCount: vacations.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: AppTextWidget(
                                  text: provider.vacations[index].comments, 
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (DateTime.now().hour >= 15 ) {
                                        final alertMessage = snackBarMessage(
                                          context: context, 
                                          message: "You can't update vacation after 3PM", 
                                          backgroundColor: Theme.of(context).primaryColor, 
                                          sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05);
                                        ScaffoldMessenger.of(context).showSnackBar(alertMessage);
                                      }else{
                                        vacation.validate(false);
                                        vacation.clearAddDates();
                                        vacation.clearupdateDates();
                                        addVacation(
                                          context: context, size: size, 
                                          isUpdating: true, 
                                          updatedStartDate: DateTime.parse(provider.vacations[index].startDate),
                                          updatedEndDate: DateTime.parse(provider.vacations[index].endDate),
                                          reason: provider.vacations[index].comments,
                                          id: provider.vacations[index].id
                                        );
                                      }
                                    },
                                    child: const Icon(CupertinoIcons.pen, size: 20,)
                                  ),
                                  const SizedBox(width: 10,),
                                  GestureDetector(
                                    onTap: ()  async{
                                      if (DateTime.now().hour >= 15 ) {
                                        final alertMessage = snackBarMessage(
                                          context: context, 
                                          message: "You can't delete vacation after 3PM", 
                                          backgroundColor: Theme.of(context).primaryColor, 
                                          sidePadding: size.width * 0.1, bottomPadding: size.height * 0.05);
                                        ScaffoldMessenger.of(context).showSnackBar(alertMessage);
                                      }else{
                                        if (provider.vacations.length == 1) {
                                          provider.confirmDeleteVacation(provider.vacations[index].id, context, size);
                                          await provider.vacationList();
                                        }else{
                                          provider.confirmDeleteVacation(provider.vacations[index].id, context, size);
                                        }
                                      }
                                    },
                                    child: const Icon(CupertinoIcons.delete, size: 20, color: Colors.red,)
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppTextWidget(text: "Start date", fontSize: 14, fontWeight: FontWeight.w500),
                                    AppTextWidget(
                                      text: DateFormat("dd/MM/yyyy").format(DateTime.parse(provider.vacations[index].startDate)), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppTextWidget(text: "End date", fontSize: 14, fontWeight: FontWeight.w500),
                                    AppTextWidget(
                                      text: DateFormat("dd/MM/yyyy").format(DateTime.parse(provider.vacations[index].endDate)), 
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w400
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: provider.vacations.length - 1 == index ? 70 : 10,)
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Add Vacation Using bottom bar
  void addVacation({
    required BuildContext context, 
    required Size size, 
    bool? isUpdating = false,
    DateTime? updatedStartDate,
    DateTime? updatedEndDate,
    String? reason,
    int? index,
    int? id
  }){
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      scrollControlDisabledMaxHeightRatio: kToolbarHeight,
      context: context, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;
            return Consumer<ProfileProvider>(
              builder: (context, profileProvider,child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: size.height * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Select start Date
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppTextWidget(text: "Start date", fontSize: 14, fontWeight: FontWeight.w500),
                                const SizedBox(height: 10,),
                                Consumer<VacationProvider>(
                                    builder: (context, provider, child) {
                                    return ElevatedButton(
                                      iconAlignment: IconAlignment.end,
                                      onPressed: () async {
                                        DateTime? startDate = await showDatePicker(
                                          context: context, 
                                          firstDate: DateTime.now(), 
                                          helpText: "Start date",
                                          lastDate: isUpdating ? updatedEndDate! : DateTime(2100),
                                          initialDate: isUpdating ? updatedStartDate : DateTime.now(),
                                        );
                                        if (isUpdating) {
                                          provider.updateTime(isStart: true, updatedDate: startDate);
                                        }else{
                                          provider.setTime(isStart: true, pickedDate: startDate);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        maximumSize: Size(size.width * 0.415, 40),
                                        minimumSize: Size(size.width * 0.415, 40),
                                        backgroundColor: Colors.transparent.withOpacity(0.0),
                                        shadowColor: Colors.transparent.withOpacity(0.0),
                                        overlayColor: Colors.transparent.withOpacity(0.1),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: provider.notSet && provider.startDate == null ? Colors.red : Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8)
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTextWidget(
                                            text: isUpdating! 
                                            ? provider.updatedStartDate != null ? DateFormat("dd MMM yyyy").format(provider.updatedStartDate!) : DateFormat("dd MMM yyyy").format(updatedStartDate!)
                                            : provider.startDate != null ? DateFormat("dd MMM yyyy").format(provider.startDate!) : "Select date", 
                                            fontSize: 12, 
                                            fontColor: Colors.black,
                                            fontWeight: FontWeight.w400
                                          ),
                                          Icon(
                                            CupertinoIcons.calendar,
                                            size: 20,
                                            color: Theme.of(context).primaryColor,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                )
                              ],
                            ),
                          ),
                          // Select end Date
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppTextWidget(text: "End date", fontSize: 14, fontWeight: FontWeight.w500),
                                const SizedBox(height: 10,),
                                 Consumer<VacationProvider>(
                                    builder: (context, provider, child) {
                                     return ElevatedButton(
                                      iconAlignment: IconAlignment.end,
                                      onPressed: () async {
                                        DateTime? endDate = await showDatePicker(
                                          context: context, 
                                          firstDate: isUpdating ? provider.updatedStartDate! : provider.startDate!, 
                                          helpText: "End date",
                                          lastDate: DateTime(2100),
                                          initialDate: isUpdating ?  provider.updatedStartDate! : provider.startDate!,
                                        );
                                        if (isUpdating) {
                                          provider.updateTime(isStart: false, updatedDate: endDate);
                                        }else{
                                          provider.setTime(isStart: false, pickedDate: endDate);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        maximumSize: Size(size.width * 0.415, 40),
                                        minimumSize: Size(size.width * 0.415, 40),
                                        backgroundColor: Colors.transparent.withOpacity(0.0),
                                        shadowColor: Colors.transparent.withOpacity(0.0),
                                        overlayColor: Colors.transparent.withOpacity(0.1),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: provider.notSet && provider.endDate == null ? Colors.red :  Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8)
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTextWidget(
                                            text: isUpdating!
                                            ? provider.updatedEndDate != null ? DateFormat("dd MMM yyyy").format(provider.updatedEndDate!) : DateFormat("dd MMM yyyy").format(updatedEndDate!)
                                            : provider.endDate != null ? DateFormat("dd MMM yyyy").format(provider.endDate!) : "Select date", 
                                            fontSize: 12, 
                                            fontColor: Colors.black,
                                            fontWeight: FontWeight.w400
                                          ),
                                          Icon(
                                            CupertinoIcons.calendar,
                                            size: 20,
                                            color: Theme.of(context).primaryColor,
                                          )
                                        ],
                                      ),
                                      );
                                   }
                                 )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Reasons for Vacation
                      const AppTextWidget(text: "Reason", fontSize: 14, fontWeight: FontWeight.w500),
                      const SizedBox(height: 10,),
                      Consumer<VacationProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: provider.notSet && provider.selectedReason.isEmpty ? Colors.red : Colors.grey.shade300
                              )
                            ),
                            width: double.infinity,
                            child: Consumer<VacationProvider>(
                              builder: (context, provider, child) {
                                return DropdownButton(
                                  borderRadius: BorderRadius.circular(8),
                                  isExpanded: true,
                                  icon: const Icon(CupertinoIcons.chevron_down, size: 20,),
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  underline: Container(),
                                  hint: AppTextWidget(text: isUpdating! ? reason! :"Select your Reason", fontSize: 14, fontWeight: FontWeight.w500),
                                  value:  provider.selectedReason.isNotEmpty ? provider.selectedReason : null,
                                  items: provider.reasons.map((reason) {
                                    return DropdownMenuItem(
                                      value: reason,
                                      child: AppTextWidget(
                                        text: reason, 
                                        fontSize: 12, 
                                        fontWeight: FontWeight.w400
                                      )
                                    );
                                  },).toList(), 
                                  onChanged: (value) {
                                    setState(() {
                                      provider.setSelectedReason(value!);
                                    });
                                  },
                                );
                              }
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 15,),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: Consumer<VacationProvider>(
                          builder: (context, provider, child) {
                            return isLoading
                            ? const LoadingButton()
                            : ButtonWidget(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              buttonName: isUpdating! ? "Update" : "Submit", 
                              onPressed: () async {
                                setState((){
                                  isLoading = true;
                                });
                                try {
                                  if (isUpdating) {
                                    await profileProvider.updateVacation(
                                      {
                                      "vacation_id": id,
                                      "start_date": DateFormat('yyyy-MM-dd').format(provider.updatedStartDate ?? updatedStartDate!),
                                      "end_date": DateFormat('yyyy-MM-dd').format(provider.updatedEndDate ?? updatedEndDate!),
                                      "comments": reason ?? provider.selectedReason
                                      }, 
                                      size, context
                                    );
                                    provider.clearupdateDates();
                                    Navigator.pop(context);
                                  }else{
                                    if (provider.startDate == null || provider.endDate == null || provider.selectedReason.isEmpty) {
                                      provider.validate(true);
                                    }else{
                                      print('Reason: ${provider.selectedReason}');
                                      await profileProvider.addVacation(
                                        {
                                        // "customer_id":prefs.getString('customerId'),
                                        "start_date": DateFormat('yyyy-MM-dd').format(provider.startDate ?? DateTime.now()),
                                        "end_date": DateFormat('yyyy-MM-dd').format(provider.endDate ?? DateTime.now()),
                                        "comments": provider.selectedReason
                                        }, 
                                        size, context
                                      );
                                      provider.clearAddDates();
                                      Navigator.pop(context);
                                    }
                                  }
                                } catch (e) {
                                  print("Can't add / update vaction $e");
                                } finally{
                                  setState((){
                                    isLoading = true;
                                  });
                                }
                              },
                            );
                          }
                        ),
                      )
                    
                    ],
                  ),
                );
              }
            );
          },
        );
      },
    );
  }
}

