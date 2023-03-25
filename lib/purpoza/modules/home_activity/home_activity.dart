import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../statemanagement/home_statemanagement/home_cubit.dart';
import '../../statemanagement/home_statemanagement/home_states.dart';
import '../../styles/icons/broken_icons.dart';

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getUserData()
        ..getPosts(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit homeCubit = HomeCubit.get(context);
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  homeCubit.titles[homeCubit.currentIndex].toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(BrokenIcons.notification)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(BrokenIcons.search)),
                ],
              ),
              body: (state is HomeLoadingState || homeCubit.homeModel == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : homeCubit.bodies[homeCubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: homeCubit.currentIndex,
                selectedItemColor: Colors.cyan,
                unselectedItemColor: Colors.blueGrey,
                onTap: (index) {
                  homeCubit.changeCurrentIndexState(context, index);
                },
                items: List.generate(
                  homeCubit.bodies.length,
                  (index) => BottomNavigationBarItem(
                      icon: Icon(
                        homeCubit.brokenIconsList[index],
                      ),
                      label: homeCubit.titles[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
