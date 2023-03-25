import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpoza/purpoza/statemanagement/init_statemanagement/signin_statemanagment/signin_states.dart';

import '../../../shared/sharedpreferences_helper/sharedpreferences.dart';
import '../../../styles/icons/broken_icons.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  IconData? passwordIcon = BrokenIcons.hide;
  bool isPasswordShown = true;
  Map<dynamic, dynamic> map = {};
  DocumentReference firebaseStream =
      FirebaseFirestore.instance.collection('init.images').doc('init');

  void changePasswordIconState() {
    if (isPasswordShown == false) {
      passwordIcon = BrokenIcons.hide;
      isPasswordShown = true;
    } else {
      passwordIcon = BrokenIcons.show;
      isPasswordShown = false;
    }
    emit(SignInChangeIconState());
  }

  Future getSignInPageImage() async {
    emit(SignInLoadingImageState());

    await firebaseStream.get().then((value) {
      map = value.data() as Map<dynamic, dynamic>;
      emit(SignInSuccessImageState());
    }).catchError((e) {
      emit(SignInErrorImageState(e));
    });
  }

  void userSignIn({
    required String? email,
    required String? password,
  }) {
    emit(SignInLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email!,
      password: password!,
    )
        .then((value) {
      if (value.user!.uid.isNotEmpty) {
        SharedPreferenceHelper.saveData(
            key: 'uId', value: value.user!.uid.toString());
        emit(SignInSuccessState());
      }
    }).catchError((error) {
      emit(SignInErrorState());
    });
  }
}
