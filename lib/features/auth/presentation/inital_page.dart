import 'package:bookme_up/core/dependency_injection/di_container.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/presentation/home.dart';
import 'package:bookme_up/features/auth/presentation/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitalPage extends StatefulWidget {
  const InitalPage({super.key});

  @override
  State<InitalPage> createState() => _InitalPageState();
}

class _InitalPageState extends State<InitalPage> {
  late AuthBloc _authBloc;
  final DIContainer diContainer = DIContainer();

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _authBloc.add(AuthAutoLoginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _authListener,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error ||
        state.authUserModel == null &&
            state.stateStatus == StateStatus.loaded) {
      ///proceed to loginpage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _authBloc,
            child: const LoginPage(),
          ),
        ),
      );
      return;
    }

    if (state.authUserModel != null &&
        state.stateStatus == StateStatus.loaded) {
      ///proceed to home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(providers: [
            BlocProvider<AuthBloc>(
                create: (BuildContext context) => diContainer.authBloc),
          ], child: HomePage(authUserModel: state.authUserModel!,)),
        ),
      );
      return;
    }
  }
}
