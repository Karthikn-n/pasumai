import 'dart:async';

import 'package:app_3/helper/shared_preference_helper.dart';
import 'package:app_3/service/connectivity_helper.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/input_field_widget.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final TextEditingController _messageController = TextEditingController();
  final SharedPreferences _prefs = SharedPreferencesHelper.getSharedPreferences();
  final List<Map<String, dynamic>> _messages = [];
  late StreamSubscription _chatRoom;
  final Map<int, bool> _isDelete = {};
  final List<int> _selectedIndexes = [];
  @override
  void initState() {
    super.initState();
    _listenToChanges();
  }

  void _listenToChanges() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("${_prefs.getString("mobile")}/bot");
    /// It will check the root node if any new childern is added
    _chatRoom =  ref.onChildAdded.listen((DatabaseEvent event) {
    if (event.snapshot.value != null) {
      final newMessage = {
        ...Map<String, dynamic>.from(event.snapshot.value as Map),
        "key": event.snapshot.key
      };

      setState(() {
        // Add the new message and sort the list
        _messages.add(newMessage);
        _messages.sort((a, b) {
          final timeA = DateTime.parse(a["time"]);
          final timeB = DateTime.parse(b["time"]);
          return timeA.compareTo(timeB);
        });
      });
    }
  });
  // This will listen to the node and parse all the current and previous children
    // _chatRoom = ref.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;

    //   if (data != null && data is Map) {
    //     final List<Map<String, dynamic>> messages = [];
    //     data.forEach((key, value) {
    //       if (value is Map) {
    //         messages.add(Map<String, dynamic>.from(value));
    //       }
    //     });

    //     setState(() {
    //       _messages = messages;
    //     });
    //   } else {
    //     print("No data or invalid format!");
    //   }
    // });
    
  }

  @override
  void deactivate() {
    // deactive the stream
    super.deactivate();
    _chatRoom.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Customer care", 
          centerTitle: false, 
          fontSize: 14,
          needBack: true,
          actions: [
            _isDelete.containsValue(true) 
              ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      if (_selectedIndexes.isNotEmpty) {
                          for (var i = 0; i < _selectedIndexes.length; i++) {
                          _deleteMessages(_selectedIndexes[i]);
                        }
                        _selectedIndexes.clear();
                      }
                      _isDelete.clear();
                    });
                  }, 
                  icon: const Icon(CupertinoIcons.delete, size: 20,)
                ),
              )
              : Container()
          ],
          onBack: () {
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (ctx, index) {
                      return _messages[index]["mobile"] == _prefs.getString("mobile")
                      // Own message on the left
                        ? Column(
                          children: [
                            const SizedBox(height: 8,),
                            Container(
                              width: _isDelete[index] != null && _isDelete[index]! ? double.infinity : null,
                              decoration: BoxDecoration(
                                color: _isDelete[index] != null && _isDelete[index]! ? Theme.of(context).primaryColor.withValues(alpha: 0.4) : null
                              ),
                              child: _messageWidget(
                                size.width * 0.7,
                                index:  index,
                                isSender: false,
                                alignment: Alignment.centerRight, 
                                size: size, 
                                isConnected: _messages[index]["isOnline"] ?? _messages[index]["isOnline"],
                                message: _messages[index]["message"] ?? "", 
                                time: DateFormat("h:mm a").format(DateTime.parse(_messages[index]["time"])).toString()
                              ),
                            ),
                          ],
                        )
                        // sender messages on the right
                        : Column(
                          children: [
                            const SizedBox(height: 4,),
                            Container(
                              width: _isDelete[index] != null && _isDelete[index]! ? double.infinity : null,
                              decoration: BoxDecoration(
                                color: _isDelete[index] != null && _isDelete[index]! ? Theme.of(context).primaryColor.withValues(alpha: 0.4) : null
                              ),
                              child: _messageWidget(
                                size.width * 0.7,
                                index:  index,
                                alignment: Alignment.centerLeft, 
                                size: size, 
                                isSender: true,
                                message: _messages[index]["message"] ?? "", 
                                // isConnected: _messages[index]["isOnline"] == null ? null : _messages[index]["isOnline"] == "true" ? true : false,
                                time: DateFormat("h:mm a").format(DateTime.parse(_messages[index]["time"])).toString()
                              ),
                            ),
                          ],
                        );
                    }
                  ),
              ),
              const SizedBox(height: 8,),
              // Message text field 
              Align(
                alignment: Alignment.bottomCenter,
                child: TextFields(
                  isObseure: false,
                  // maxHeight: kToolbarHeight - 6,
                  borderRadius: 25,
                  controller: _messageController,
                  textInputAction: TextInputAction.send,
                  hintText: "Message",
                  maxLine: 5,
                  suffixIcon: IconButton(
                    
                    onPressed: () async {
                      // This refers the root of the database
                      DatabaseReference ref = FirebaseDatabase.instance.ref("${_prefs.getString("mobile")}/bot");
                      /// Push is help to generate unique id for every time the value is set
                      /// Set is used to set the value in the same key if it is updated
                      await ref.push().set({
                        "mobile": _prefs.getString("mobile"),
                        "time": DateTime.now().toString(),
                        "message": _messageController.text,
                        "isOnline": connectivityService.isConnected
                      }).whenComplete(() {
                        setState(() {
                          // Clear and remove the focus from the text field
                          FocusScope.of(context).unfocus();
                          _messageController.clear();
                        });
                      },);
                      print(_messages);
                    }, 
                    icon: const Icon(Icons.send_rounded)
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  // Message box 
  Widget _messageWidget(
    double maxWidth,
    {
    required int index,
    required AlignmentGeometry alignment,
    required Size size,
    required String message,
    required String time,
    bool? isConnected,
    bool? isSender
  }){
    return  Align(
      alignment: alignment,
      child: Material(
        color: Colors.transparent.withValues(alpha: 0.0),
        child: InkWell(
          splashColor: Colors.white10,
          onTap: () {
            _isDelete.containsValue(true) && _isDelete[index] == null
             ?  setState(() {
                  _isDelete[index] = true;
                  _selectedIndexes.add(index);
                })
             :  setState(() {
                  _isDelete[index] = false;
                  _isDelete.remove(index);
                  _selectedIndexes.remove(index);
                });
                 print(_selectedIndexes);
          },
          onLongPress: () {
             setState(() {
               _isDelete[index] = true;
               _selectedIndexes.add(index);
             });
             print(_selectedIndexes);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: 0
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: AppTextWidget(
                    text: message, 
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    fontColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 5,),
                Row(
                  children: [
                    AppTextWidget(
                      text: time, 
                      fontWeight: FontWeight.w500,
                      fontSize: 8,
                      fontColor: Colors.white,
                    ),
                    const SizedBox(width: 4,),
                    isConnected == null 
                      ? isSender! ? Container() : const Icon(CupertinoIcons.clock, size: 12, color: Colors.white,)
                      : isConnected 
                        ? const Icon(Icons.done_all, size: 12, color: Colors.white,)
                        : const Icon(Icons.done, size: 12, color: Colors.white,)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete the selected messages
  Future<void> _deleteMessages(int index) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("${_prefs.getString("mobile")}/bot");

    // Get the message's unique key
    final String messageKey = _messages[index]["key"];

    // Delete the message using the key
    await ref.child(messageKey).remove().then((_) {
      setState(() {
        _messages.removeAt(index);
        _isDelete.remove(index);
      });
      print("Message deleted successfully!");
    }).catchError((error) {
      print("Error deleting message: $error");
    });
  }
}

