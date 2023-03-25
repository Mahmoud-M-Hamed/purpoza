import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../components/reusable_components.dart';
import '../../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../../statemanagement/home_statemanagement/home_states.dart';
import '../../../../../styles/icons/broken_icons.dart';

class EditProfileActivity extends StatelessWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  EditProfileActivity({super.key});

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
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(BrokenIcons.arrow_left_2)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: (state is UpdateSuccessDataState ||
                              state is UpdateLoadingDataState ||
                              state is UploadCoverImageLoadingState ||
                              state is UploadProfileImageLoadingState)
                          ? null
                          : () async {
                              await homeCubit
                                  .updateUserProfileData(
                                      bio: bioController.text,
                                      userName: userNameController.text)
                                  .whenComplete(
                                    () => homeCubit.getUserData().whenComplete(
                                          () => Navigator.of(context).pop(),
                                        ),
                                  );
                            },
                      child: const Text('Update'),
                    ),
                  ),
                ],
                title: const Text(
                  'Update Profile',
                ),
              ),
              body: (state is HomeLoadingState ||
                      homeCubit.homeModel == null ||
                      state is UploadCoverImageLoadingState ||
                      state is UploadProfileImageLoadingState)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : editProfileBuildBody(state, context, homeCubit),
            ),
          );
        },
      ),
    );
  }

  Widget editProfileBuildBody(HomeStates state, context, HomeCubit homeCubit) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: (homeCubit.coverImage == null)
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    homeCubit.homeModel!.coverImage.toString()),
                              )
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(homeCubit.coverImage!),
                              ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.cyan,
                              child: IconButton(
                                  onPressed: () {
                                    homeCubit.pickCoverImage();
                                  },
                                  icon: const Icon(
                                    BrokenIcons.camera,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: (homeCubit.profileImage == null)
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 63,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 60,
                                backgroundImage: NetworkImage(homeCubit
                                    .homeModel!.profileImage
                                    .toString()),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.cyan,
                                        child: IconButton(
                                            onPressed: () {
                                              homeCubit.pickProfileImage();
                                            },
                                            icon: const Icon(
                                              BrokenIcons.camera,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 63,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 60,
                                backgroundImage:
                                    FileImage(homeCubit.profileImage!),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.cyan,
                                        child: IconButton(
                                            onPressed: () {
                                              homeCubit.pickProfileImage();
                                            },
                                            icon: const Icon(
                                              BrokenIcons.camera,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                homeCubit.homeModel!.userName.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                (homeCubit.homeModel!.bio != null ||
                        homeCubit.homeModel!.bio != "")
                    ? homeCubit.homeModel!.bio.toString()
                    : 'write a bio...',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextField(
                textEditingController: userNameController,
                labelText: 'User Name',
                prefixIcon: BrokenIcons.user_1,
                obscureText: false,
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextField(
                labelText: 'bio',
                textEditingController: bioController,
                prefixIcon: BrokenIcons.messages_2,
                obscureText: false,
              ),
            ],
          ),
        ),
      );
}
