import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpoza/purpoza/styles/icons/broken_icons.dart';
import '../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../statemanagement/home_statemanagement/home_states.dart';

class FeedsActivity extends StatelessWidget {
  TextEditingController commentController = TextEditingController();

  FeedsActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return (state is HomeLoadingState ||
                state is GetPostLoadingState ||
                homeCubit.postModel == null)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: const [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 10,
                          child: Image(
                            height: 200,
                            width: double.infinity,
                            image: AssetImage(
                              'assets/images/signin_0.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Communicate with friends',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeCubit.postsList.length,
                      itemBuilder: (context, index) => layoutItemsBuilder(
                        context,
                        index,
                        homeCubit,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget layoutItemsBuilder(context, int i, HomeCubit homeCubit) => Card(
        elevation: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                        homeCubit.postsList[i].userImage.toString()),
                    backgroundColor: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            homeCubit.postsList[i].userName.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      Text(
                        homeCubit.postsList[i].dateTime.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    BrokenIcons.more,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                endIndent: 8,
                indent: 8,
              ),
              Text(
                HomeCubit.get(context).postsList[i].postText.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                child: (homeCubit.postsList[i].postImage == null ||
                        homeCubit.postsList[i].postImage == '')
                    ? Container()
                    : Image(
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          homeCubit.postsList[i].postImage.toString(),
                        ),
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        BrokenIcons.heart,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        (homeCubit.likeMap['${homeCubit.likePostList[i]}'] ==
                                false)
                            ? '0 Like'
                            : '1 Like',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.blueGrey,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        BrokenIcons.comment_2_text,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '12 Comment',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.blueGrey, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                endIndent: 8,
                indent: 8,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      homeCubit.homeModel!.profileImage.toString(),
                    ),
                    backgroundColor: Colors.black,
                    radius: 18,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'write a comment...',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            BrokenIcons.send,
                            size: 18,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '|',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                  ),
                  InkWell(
                    onTap: () async {
                      (homeCubit.likeMap['${homeCubit.likePostList[i]}'] ==
                              true)
                          ? homeCubit
                              .disLike(homeCubit.likePostList[i].toString())
                          : homeCubit.addLike(
                              homeCubit.likePostList[i].toString(), i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            (homeCubit.likeMap[
                                        '${homeCubit.likePostList[i]}'] ==
                                    true)
                                ? Icons.favorite
                                : BrokenIcons.heart,
                            color: Colors.red,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            (homeCubit.likeMap[
                                        '${homeCubit.likePostList[i]}'] ==
                                    true)
                                ? 'Liked'
                                : 'Like',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
