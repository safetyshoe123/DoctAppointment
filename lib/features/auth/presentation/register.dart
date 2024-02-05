import 'dart:math';

import 'package:bookme_up/core/dependency_injection/di_container.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/core/global_widgets/snackbar_widget.dart';
import 'package:bookme_up/core/utils/guard.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/domain/models/register.model.dart';
import 'package:bookme_up/features/auth/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final DIContainer diContainer = DIContainer();
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void clearText() {
    _emailController.clear();
    _firstNameController.clear();
    _firstNameController.clear();
    _passwordController.clear();
    _passwordConfirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/green_bg.png'), fit: BoxFit.cover, ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            forceMaterialTransparency: true,
            centerTitle: true,
            title: Text(
              'Register',
              style: GoogleFonts.farro(
                color: const Color.fromARGB(234, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 40, 
                shadows: [
                  Shadow(
                      color: Colors.green.shade700, offset: const Offset(5, 7)),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: _authBlocListener,
          builder: (context, state) {
            if (state.stateStatus == StateStatus.loading) {
              return _loadingWidget();
            }
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: screenSize.height * 0.2,
                        width: 400,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/reg_bg.png'),
                              alignment: Alignment.bottomCenter),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          width: max(100, 450),
                          child: TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: const Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: FaIcon(FontAwesomeIcons.userAstronaut),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text('Email'),
                            ),
                            validator: (String? val) {
                              return Guard.againstInvalidEmail(val, 'Email');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          width: max(100, 450),
                          child: TextFormField(
                            controller: _firstNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: const Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: FaIcon(FontAwesomeIcons.userAstronaut),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text('Name'),
                            ),
                            validator: (String? val) {
                              return Guard.againstEmptyString(val, 'Name');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          width: max(100, 450),
                          child: TextFormField(
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: state.obscure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: const Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: FaIcon(FontAwesomeIcons.userLock),
                              ),
                              // suffixIcon: Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 12, vertical: 12),
                              //   child: IconButton(
                              //     onPressed: () {},
                              //     icon: Icon(
                              //       state.obscure
                              //           ? Icons.visibility
                              //           : Icons.visibility_off,
                              //     ),
                              //   ),
                              // ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text('Password'),
                            ),
                            validator: (String? val) {
                              return Guard.againstEmptyString(val, 'Password');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          width: max(100, 450),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordConfirmController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: const Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: FaIcon(FontAwesomeIcons.userAstronaut),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text('Confirm Password'),
                            ),
                            validator: (String? val) {
                              return Guard.againstNotMatch(
                                  val, _passwordController.text, 'Password');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: max(90, 400),
                        child: const Divider(),
                      ),
                      SizedBox(
                        width: max(100, 450),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.green,
                              elevation: 10,
                              fixedSize: const Size.fromHeight(47),
                            ),
                            onPressed: () {
                              _register(context);
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.farro(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _authBlocListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context, Colors.red.shade300);
    }

    if (state.authUserModel != null) {
      SnackBarUtils.defualtSnackBar('Success!', context, Colors.green);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (BuildContext context) => diContainer.authBloc,
                ),
                // BlocProvider<TodoBloc>(
                //   create: (BuildContext context) => diContainer.todoBloc,
                // ),
              ],
              child: HomePage(
                  authUserModel: state.authUserModel!,
                  ),
            ),
          ),
          ModalRoute.withName('/'));
    }
    clearText();
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthRegisterEvent(
          registerModel: RegisterModel(
            email: _emailController.text,
            name: _firstNameController.text,
            password: _passwordController.text,
            confirmPassword: _passwordConfirmController.text,
          ),
        ),
      );
    }
  }
}
