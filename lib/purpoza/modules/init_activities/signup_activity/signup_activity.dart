import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/constants.dart';
import '../../../components/reusable_components.dart';
import '../../../statemanagement/init_statemanagement/signup_statemanagment/signup_cubit.dart';
import '../../../statemanagement/init_statemanagement/signup_statemanagment/signup_states.dart';
import '../../../styles/icons/broken_icons.dart';
import '../signin_activity/signin_activity.dart';

class SignUpActivity extends StatelessWidget {
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController confirmPasswordController =
      TextEditingController();
  static TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SignUpActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit()..getSignUpPageImage(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SignUpErrorState) {
            showToast(
              msg: state.error.toString(),
              toastState: ToastState.ERROR,
            );
          }
          if (state is SignUpSuccessState) {
            showToast(
              msg: "Sign Up Successfully",
              toastState: ToastState.SUCCESS,
            );
          }
        },
        builder: (context, state) {
          SignUpCubit signUpCubit = SignUpCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SignInActivity(),
                                ),
                              );
                            },
                            icon: const Icon(
                              BrokenIcons.arrow_left_2,
                            ),
                          ),
                        ),
                        (state is SignUpLoadingImageState)
                            ? const SizedBox(
                                height: 100,
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: (signUpCubit.map.isEmpty == true)
                                    ? const SizedBox(
                                        height: 100,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          signUpCubit.map['signUp'].toString(),
                                        ),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Sign Up to $mainTitle",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                        ),
                        Text(
                          "Sign Up Now To Chat With Friends...",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: userNameController,
                            labelText: "User Name",
                            prefixIcon: Icons.person,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'User Name mustn\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: emailController,
                            labelText: "E-Mail",
                            prefixIcon: BrokenIcons.message,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'E-Mail address mustn\'t be empty';
                              } else if (!value.contains("@") ||
                                  !value.contains('.')) {
                                return 'E-Mail must have @example.com';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: phoneNumberController,
                            labelText: "Phone Number",
                            prefixIcon: Icons.phone,
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Phone Number mustn\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: passwordController,
                            labelText: "Password",
                            prefixIcon: BrokenIcons.lock,
                            suffixIcon: signUpCubit.passwordIcon,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: signUpCubit.isPasswordShown,
                            onPressedIconSuffix: () {
                              signUpCubit.changePasswordIconState();
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password must\'t be empty';
                              } else if (value.length <= 5) {
                                return 'Password too short';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: confirmPasswordController,
                            labelText: "Confirm Password",
                            prefixIcon: BrokenIcons.lock,
                            suffixIcon: signUpCubit.confirmPasswordIcon,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: signUpCubit.isConfirmPasswordShown,
                            onPressedIconSuffix: () {
                              signUpCubit.changeConfirmPasswordIconState();
                            },
                            validator: (String? value) {
                              if (value != passwordController.text) {
                                return "Passwords Not the Same";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        (state is SignUpLoadingState)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : defaultMaterialButton(
                                color: mainColor,
                                splashColor: Colors.black,
                                vertical: 10,
                                horizontal: 40,
                                child: Text(
                                  "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    signUpCubit.userSignUp(
                                      context: context,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      userName: userNameController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                      phoneNumber: phoneNumberController.text,
                                    );
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
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
