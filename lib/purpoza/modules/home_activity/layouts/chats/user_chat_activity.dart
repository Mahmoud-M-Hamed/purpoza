import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/constants.dart';
import '../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../statemanagement/home_statemanagement/home_states.dart';
import '../../../../styles/icons/broken_icons.dart';

// ignore: must_be_immutable
class UserChatActivity extends StatelessWidget {
  int index;
  UserChatActivity(this.index, {super.key});

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getUserData()
        ..getChatUsers(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit homeCubit = HomeCubit.get(context);
          HomeCubit.get(context).receiveMessage(
            receiverId: HomeCubit.get(context)
                .chatUsersList[HomeCubit.get(context).chatIndex]
                .uId
                .toString(),
          );
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leadingWidth: 30,
                title: (homeCubit.chatUsersList.isEmpty)
                    ? Container()
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              homeCubit.chatUsersList[homeCubit.chatIndex]
                                  .profileImage
                                  .toString(),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            homeCubit
                                .chatUsersList[homeCubit.chatIndex].userName
                                .toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    BrokenIcons.arrow_left_2,
                  ),
                ),
              ),
              body: (homeCubit.chatUsersList.isEmpty)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemCount: homeCubit.receiveMessageList.length,
                                itemBuilder: (context, index) {
                                  if (FirebaseAuth.instance.currentUser!.uid ==
                                      homeCubit
                                          .chatUsersList[homeCubit.chatIndex]
                                          .uId) {
                                    return buildReceiverMessage(
                                        homeCubit, index);
                                  } else {
                                    return buildSenderMessage(homeCubit, index);
                                  }
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: messageController,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          labelText: 'Type message',
                                          contentPadding: EdgeInsets.all(20),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 62,
                                      decoration: const BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          homeCubit
                                              .sendMessage(
                                                dateTime:
                                                    DateTime.now().toString(),
                                                receiverId: homeCubit
                                                    .chatUsersList[
                                                        homeCubit.chatIndex]
                                                    .uId
                                                    .toString(),
                                                text: messageController.text,
                                              )
                                              .whenComplete(
                                                () => homeCubit.receiveMessage(
                                                  receiverId: homeCubit
                                                      .chatUsersList[
                                                          homeCubit.chatIndex]
                                                      .uId
                                                      .toString(),
                                                ),
                                              );
                                        },
                                        icon: const Icon(
                                          BrokenIcons.send,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSenderMessage(HomeCubit homeCubit, index) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              homeCubit.receiveMessageList[index].text.toString(),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Align(
            alignment: Alignment.bottomRight,
            heightFactor: 1.35,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                homeCubit.chatUsersList[homeCubit.chatIndex].profileImage
                    .toString(),
              ),
            ),
          ),
        ],
      );

  Widget buildReceiverMessage(HomeCubit homeCubit, int index) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            heightFactor: 1.35,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                homeCubit.chatUsersList[homeCubit.chatIndex].profileImage
                    .toString(),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              (homeCubit.receiveMessageList.isEmpty)
                  ? 'Bad Connection'
                  : homeCubit.receiveMessageList[index].text.toString(),
            ),
          ),
        ],
      );
}
