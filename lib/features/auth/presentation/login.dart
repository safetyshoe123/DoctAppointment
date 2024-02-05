import 'dart:math';
import 'package:bookme_up/core/dependency_injection/di_container.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/core/global_widgets/snackbar_widget.dart';
import 'package:bookme_up/core/utils/guard.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/domain/models/login.model.dart';
import 'package:bookme_up/features/auth/presentation/home.dart';
import 'package:bookme_up/features/auth/presentation/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final DIContainer diContainer = DIContainer();
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  void clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/green_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          // backgroundColor:const Color.fromARGB(0, 74, 57, 87),
          centerTitle: true,
          title: Text(
            'DoctAPP',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(234, 255, 255, 255),
              fontSize: 40,
              shadows: [
                Shadow(
                    color: Colors.green.shade700, offset: const Offset(5, 7)),
              ],
            ),
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: _authBlocListener,
          builder: (context, state) {
            if (state.stateStatus == StateStatus.loading) {
              return _loadingWidget();
            }
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 230,
                        width: 400,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/doc.png'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: max(100, 450),
                        child: TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: state.obscure,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: FaIcon(FontAwesomeIcons.userLock),
                            ),
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
                            fixedSize: const Size.fromHeight(47),
                            elevation: 10,
                          ),
                          onPressed: () {
                            _login(context);
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.farro(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do you have an account?',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<AuthBloc>(
                                        create: (BuildContext context) =>
                                            diContainer.authBloc,
                                      ),
                                      // BlocProvider<TodoBloc>(
                                      //   create: (BuildContext context) =>
                                      //       diContainer.todoBloc,
                                      // )
                                    ],
                                    child: const RegisterPage(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Sign UP!',
                              style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
      SnackBarUtils.defualtSnackBar('Login Success!', context, Colors.green);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (BuildContext context) => diContainer.authBloc,
                ),
              ],
              child: HomePage(
                authUserModel: state.authUserModel!,
              ),
            ),
          ),
          ModalRoute.withName('/'));
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
          // backgroundColor: Color(ApplicationCache.CHECKING),
          // valueColor: Animation<Color>(),
          ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthLoginEvent(
          logInModel: LoginModel(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
    clearText();
  }
}
