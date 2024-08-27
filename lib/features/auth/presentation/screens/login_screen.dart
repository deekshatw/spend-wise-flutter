import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/utils/assets.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/label_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/core/widgets/text_field_widget.dart';
import 'package:spend_wise/features/auth/bloc/auth_bloc.dart';
import 'package:spend_wise/features/auth/presentation/screens/register_screen.dart';
import 'package:spend_wise/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc bloc = AuthBloc();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Spend Ease'),
      // ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: bloc,
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            // return Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: _emailController,
            //         decoration: const InputDecoration(
            //           labelText: 'Email',
            //         ),
            //       ),
            //       TextField(
            //         controller: _passwordController,
            //         decoration: const InputDecoration(
            //           labelText: 'Password',
            //         ),
            //       ),
            //       const SizedBox(height: 20),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.blue,
            //         ),
            //         onPressed: () {
            //           bloc.add(AuthLoginEvent(
            //             _emailController.text,
            //             _passwordController.text,
            //             context,
            //           ));
            //         },
            //         child: const Text(
            //           'Login',
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (_) => const RegisterScreen()));
            //         },
            //         child: const Text('Register'),
            //       ),
            //     ],
            //   ),
            // );
            return const SizedBox();
          } else if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          height: 60,
                          width: 60,
                          Assets.deadPNG,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Login now to continue using Spend Ease',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.charcoal.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LabelWidget(label: 'Email'),
                            TextFieldWidget(
                              controller: _emailController,
                              label: 'Enter your email',
                              isPassword: false,
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                        .hasMatch(val!)
                                    ? null
                                    : 'Please provide a valid email';
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const LabelWidget(label: 'Password'),
                            TextFieldWidget(
                              controller: _passwordController,
                              label: 'Enter your password',
                              isPassword: true,
                              validator: (val) {
                                return val!.isEmpty || val.length < 8
                                    ? 'Password must be at least 8 characters'
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.charcoal.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Login',
                        onTap: () {
                          if ((_formKey.currentState!.validate())) {
                            bloc.add(AuthLoginEvent(
                              _emailController.text,
                              _passwordController.text,
                              context,
                            ));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account? '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterScreen()));
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColors.charcoal,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
