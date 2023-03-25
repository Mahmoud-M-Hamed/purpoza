import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpoza/purpoza/statemanagement/init_statemanagement/signup_statemanagment/signup_states.dart';

import '../../../models/init_models/signup_model/signup_model.dart';
import '../../../modules/init_activities/signin_activity/signin_activity.dart';
import '../../../styles/icons/broken_icons.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  IconData? passwordIcon = BrokenIcons.hide;
  bool isPasswordShown = true;
  IconData? confirmPasswordIcon = BrokenIcons.hide;
  bool isConfirmPasswordShown = true;
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
    emit(SignUpChangeIconState());
  }

  void changeConfirmPasswordIconState() {
    if (isConfirmPasswordShown == false) {
      confirmPasswordIcon = BrokenIcons.hide;
      isConfirmPasswordShown = true;
    } else {
      confirmPasswordIcon = BrokenIcons.show;
      isConfirmPasswordShown = false;
    }
    emit(SignUpChangeIconState());
  }

  Future getSignUpPageImage() async {
    emit(SignUpLoadingImageState());

    await firebaseStream.get().then((value) {
      map = value.data() as Map<dynamic, dynamic>;
      emit(SignUpSuccessImageState());
    }).catchError((e) {
      emit(SignUpErrorImageState(e));
    });
  }

  void userSignUp({
    required context,
    required String? userName,
    required String? email,
    required String? password,
    required String? confirmPassword,
    required String? phoneNumber,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    )
        .then((value) {
      SignUpModel signUpModel = SignUpModel(
        email: email,
        password: password,
        userName: userName,
        phoneNumber: phoneNumber,
        uId: value.user!.uid,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(signUpModel.toMap())
          .then((value) {
        emit(SignUpSuccessState());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInActivity()),
        );
      }).catchError((error) {
        emit(SignUpErrorState(error));
      });
    }).catchError((error) {
      emit(SignUpErrorState(error));
    });
  }
}
