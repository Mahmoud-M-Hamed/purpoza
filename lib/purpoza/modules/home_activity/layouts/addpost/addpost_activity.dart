import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../components/constants.dart';
import '../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../statemanagement/home_statemanagement/home_states.dart';
import '../../../../styles/icons/broken_icons.dart';
import '../../home_activity.dart';

class AddPostActivity extends StatelessWidget {
  final TextEditingController createPostController = TextEditingController();
  final DateTime dateTime = DateTime.now();

  AddPostActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit homeCubit = HomeCubit.get(context);

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leadingWidth: 20,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeActivity()));
                    },
                    icon: const Icon(BrokenIcons.arrow_left_2)),
                title: const Text(
                  'Create Post',
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                      onPressed: (state is CreatePostLoadingState ||
                              state is UploadPostImageLoadingState)
                          ? null
                          : () async {
                              await homeCubit
                                  .createPost(
                                    context,
                                    postText: createPostController.text,
                                    dateTime: DateFormat.yMMMMEEEEd()
                                        .format(dateTime)
                                        .toString(),
                                  )
                                  .whenComplete(
                                    () => homeCubit.navigateReplacement(
                                      context,
                                      const HomeActivity(),
                                    ),
                                  );
                            },
                      child: const Text(
                        'post',
                      ),
                    ),
                  ),
                ],
              ),
              body: (state is CreatePostLoadingState ||
                      state is UploadPostImageLoadingState ||
                      state is HomeLoadingState)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      HomeCubit.get(context)
                                          .homeModel!
                                          .profileImage
                                          .toString()),
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
                                          HomeCubit.get(context)
                                              .homeModel!
                                              .userName
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                  ],
                                ),
                              ],
                            ),
                            TextField(
                              controller: createPostController,
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                              maxLines: null,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'what\'s on your mind ...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              height: (homeCubit.postImage != null) ? 200 : 0,
                              width: double.infinity,
                              decoration: (homeCubit.postImage != null)
                                  ? BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              FileImage(homeCubit.postImage!)),
                                    )
                                  : const BoxDecoration(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    splashColor:
                                        Colors.cyanAccent.withOpacity(0.5),
                                    onTap: () {
                                      HomeCubit.get(context).pickPostImage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            BrokenIcons.image,
                                            color: mainColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'photo',
                                            style: TextStyle(
                                              color: mainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                  InkWell(
                                    splashColor:
                                        Colors.cyanAccent.withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            BrokenIcons.users_3,
                                            color: mainColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'tags',
                                            style: TextStyle(color: mainColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {},
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
}
