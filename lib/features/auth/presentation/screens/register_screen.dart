import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/utils/assets.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/core/widgets/label_widget.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/core/widgets/text_field_widget.dart';
import 'package:spend_wise/features/auth/bloc/auth_bloc.dart';
import 'package:spend_wise/features/auth/presentation/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthBloc bloc = AuthBloc();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: bloc,
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is AuthErrorState) {
            return Text(state.message);
          } else if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthSuccessState) {
            return const Center(child: Text('Registration successful'));
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
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
                        'Register Now',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Welcome to Spend Ease!',
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
                            const LabelWidget(label: 'Full Name'),
                            TextFieldWidget(
                              controller: _nameController,
                              label: 'Enter your name',
                              isPassword: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
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
                            const SizedBox(
                              height: 6,
                            ),
                            const LabelWidget(label: 'Confirm Password'),
                            TextFieldWidget(
                              controller: _confirmPasswordController,
                              label: 'Re-enter your password',
                              isPassword: true,
                              validator: (val) {
                                return val!.isEmpty || val.length < 8
                                    ? 'Both passwords must match'
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        label: 'Register',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            bloc.add(AuthRegisterEvent(
                              _nameController.text,
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
                          Text('Already have an account? '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()));
                            },
                            child: const Text(
                              'Login',
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
