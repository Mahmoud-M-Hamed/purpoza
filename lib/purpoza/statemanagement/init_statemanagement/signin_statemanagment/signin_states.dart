abstract class SignInStates {}

class SignInInitialState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInSuccessState extends SignInStates {}

class SignInErrorState extends SignInStates {}

class SignInLoadingImageState extends SignInStates {}

class SignInSuccessImageState extends SignInStates {}

class SignInErrorImageState extends SignInStates {
  final dynamic error;

  SignInErrorImageState(this.error);
}

class SignInChangeIconState extends SignInStates {}
