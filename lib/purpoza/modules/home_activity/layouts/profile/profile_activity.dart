import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../../../statemanagement/home_statemanagement/home_states.dart';
import '../../../../styles/icons/broken_icons.dart';
import 'editprofile/edit_profile_activity.dart';

class ProfileActivity extends StatelessWidget {
  const ProfileActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit homeCubit = HomeCubit.get(context);
          return (state is HomeLoadingState || homeCubit.homeModel == null)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
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
                                alignment: Alignment.topCenter,
                                height: 170,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(homeCubit
                                        .homeModel!.coverImage
                                        .toString()),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 63,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 60,
                                    backgroundImage: NetworkImage(homeCubit
                                        .homeModel!.profileImage
                                        .toString()),
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: List.generate(
                              HomeCubit.get(context).profileDetails.length,
                              (index) => Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                  HomeCubit.get(context)
                                                      .profileNumbers[index],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              Text(
                                                  HomeCubit.get(context)
                                                      .profileDetails[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        if (index <
                                            HomeCubit.get(context)
                                                    .profileDetails
                                                    .length -
                                                1)
                                          Text(
                                            '|',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.grey[700]),
                                          )
                                      ],
                                    ),
                                  )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Add Photo'))),
                            const SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileActivity()));
                                },
                                child: const Icon(BrokenIcons.edit_square)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
