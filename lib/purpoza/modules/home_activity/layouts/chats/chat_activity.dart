import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpoza/purpoza/modules/home_activity/layouts/chats/user_chat_activity.dart';
import '../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../statemanagement/home_statemanagement/home_states.dart';

class ChatActivity extends StatelessWidget {
  const ChatActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        HomeCubit.get(context).getChatUsers();
        return BlocConsumer<HomeCubit, HomeStates>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            HomeCubit homeCubit = HomeCubit.get(context);
            return (homeCubit.homeModel == null ||
                    state is ChatGetUsersLoadingState)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                          homeCubit.chatUsersList.length,
                          (index) => buildChatUser(
                            ctx,
                            homeCubit,
                            index,
                          ),
                        ),
                      ),
                    ),
                  );
          },
        );
      },
    );
  }

  Widget buildChatUser(ctx, HomeCubit homeCubit, int index) => InkWell(
        onTap: () {
          homeCubit.changeChatIndexState(ctx, index);
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (ctx) => UserChatActivity(index),
            ),
          );
        },
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    homeCubit.chatUsersList[index].profileImage.toString(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  homeCubit.chatUsersList[index].userName.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (index < homeCubit.chatUsersList.length - 1)
              const Divider(
                color: Colors.blueGrey,
                height: 1,
                indent: 10,
                endIndent: 10,
              )
          ],
        ),
      );
}
