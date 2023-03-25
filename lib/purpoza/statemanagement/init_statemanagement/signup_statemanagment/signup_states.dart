abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {}

class SignUpErrorState extends SignUpStates {
  final dynamic error;

  SignUpErrorState(this.error);
}

class SignUpLoadingImageState extends SignUpStates {}

class SignUpSuccessImageState extends SignUpStates {}

class SignUpErrorImageState extends SignUpStates {
  final dynamic error;

  SignUpErrorImageState(this.error);
}

class SignUpChangeIconState extends SignUpStates {}
