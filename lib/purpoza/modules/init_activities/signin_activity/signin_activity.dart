import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/constants.dart';
import '../../../components/reusable_components.dart';
import '../../../statemanagement/init_statemanagement/signin_statemanagment/signin_cubit.dart';
import '../../../statemanagement/init_statemanagement/signin_statemanagment/signin_states.dart';
import '../../../styles/icons/broken_icons.dart';
import '../../home_activity/home_activity.dart';
import '../signup_activity/signup_activity.dart';

class SignInActivity extends StatelessWidget {
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  SignInActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignInCubit()..getSignInPageImage(),
      child: BlocConsumer<SignInCubit, SignInStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SignInCubit signInCubit = SignInCubit.get(context);
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
                        (state is SignInLoadingImageState)
                            ? const SizedBox(
                                height: 100,
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: (signInCubit.map.isEmpty == true)
                                    ? const SizedBox(
                                        height: 100,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          signInCubit.map['signIn'].toString(),
                                        ),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Welcome to $mainTitle",
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
                          "Communicate With People Now...",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: defaultTextField(
                            textEditingController: passwordController,
                            labelText: "Password",
                            prefixIcon: BrokenIcons.lock,
                            suffixIcon: signInCubit.passwordIcon,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: signInCubit.isPasswordShown,
                            onPressedIconSuffix: () {
                              signInCubit.changePasswordIconState();
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password mustn\'t be empty';
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
                        (state is SignInLoadingState)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : defaultMaterialButton(
                                color: mainColor,
                                splashColor: Colors.black,
                                vertical: 10,
                                horizontal: 40,
                                child: Text(
                                  "Sign In",
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
                                    signInCubit.userSignIn(
                                        email: emailController.text,
                                        password: passwordController.text);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeActivity(),
                                      ),
                                    );
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => SignUpActivity(),
                                  ),
                                );
                              },
                              child: const Text("Sign Up"),
                            ),
                          ],
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
