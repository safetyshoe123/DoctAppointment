import 'package:bookme_up/core/dependency_injection/di_container.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/core/global_widgets/snackbar_widget.dart';
import 'package:bookme_up/core/utils/docpics.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/domain/models/auth_user.model.dart';
import 'package:bookme_up/features/auth/presentation/doc_profile.dart';
import 'package:bookme_up/features/auth/presentation/doc_type.dart';
import 'package:bookme_up/features/auth/presentation/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.authUserModel});
  final AuthUserModel authUserModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DIContainer diContainer = DIContainer();
  int currentPageIndex = 0;
  late AuthBloc _authBloc;
  late AuthUserModel _authUserModel;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _authBloc.add(GetDoctorEvent());
    _authUserModel = widget.authUserModel;
    _authBloc.add(AuthAutoLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Size containerSizeBottom = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _authListener,
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return PopScope(
          canPop: false,
          child: Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/green_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SearchBar(
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      leading: const Icon(Icons.search),
                      constraints: const BoxConstraints(
                        minWidth: 360.0,
                        maxWidth: 750.0,
                        minHeight: 56.0,
                      ),
                      hintText: 'Search your Doctor',
                      onSubmitted: (value) {
                        _searchDoctor(context, value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              SizedBox(
                                height: containerSizeBottom.height / 9,
                                width: containerSizeBottom.width / 4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (BuildContext context) =>
                                              diContainer.authBloc,
                                          child: DocType(
                                            doctype: 'Dentistry',
                                            patientName: _authUserModel.name,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor('#e8f7ee'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadowColor:
                                        const Color.fromARGB(255, 20, 71, 24),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.tooth,
                                    color: Color.fromARGB(255, 231, 219, 106),
                                  ),
                                ),
                              ),
                              Text(
                                'Dental Service',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color.fromARGB(200, 34, 33, 33),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: Column(
                            children: [
                              SizedBox(
                                height: containerSizeBottom.height / 9,
                                width: containerSizeBottom.width / 4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (BuildContext context) =>
                                              diContainer.authBloc,
                                          child: DocType(
                                            doctype: 'Cardiology',
                                            patientName: _authUserModel.name,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor('#e8f7ee'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.solidHeart,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                              ),
                              Text(
                                'Heart Surgeon',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color.fromARGB(200, 34, 33, 33),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              SizedBox(
                                height: containerSizeBottom.height / 9,
                                width: containerSizeBottom.width / 4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (BuildContext context) =>
                                              diContainer.authBloc,
                                          child: DocType(
                                            doctype: 'Optometrist',
                                            patientName: _authUserModel.name,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor('#e8f7ee'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueAccent.shade200,
                                  ),
                                ),
                              ),
                              Text(
                                'Eye Treatment',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color.fromARGB(200, 34, 33, 33),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: containerSizeBottom.height / 1.6,
                      width: containerSizeBottom.width,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 20,
                        ),
                        child: RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: Builder(builder: (context) {
                            if (state.isEmpty == true) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: ListView(
                                  children: [
                                    Center(
                                        child: Text(
                                      'Doctor does not exist!',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: state.docModel.length,
                              itemBuilder: (context, index) {
                                final docList = state.docModel[index];
                                final docPicsList = DoctorPics.arrayPics[index];
                                return Card(
                                  color: HexColor('#e8f7ee'),
                                  shadowColor: Colors.green.shade800,
                                  elevation: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox.square(
                                        dimension: 100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              filterQuality:
                                                  FilterQuality.medium,
                                              fit: BoxFit.cover,
                                              image: AssetImage(docPicsList),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenSize.width / 2.2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Dr. ${docList.docName}',
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      200, 34, 33, 33),
                                                ),
                                              ),
                                              Text(
                                                docList.specialization,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 13,
                                                  color: const Color.fromARGB(
                                                      200, 34, 33, 33),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlocProvider(
                                                        create: (BuildContext
                                                                context) =>
                                                            diContainer
                                                                .authBloc,
                                                        child: DocProfile(
                                                          doctorsModel: docList,
                                                          index: index,
                                                          patientName: _authUserModel.name,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Show more',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // bottomNavigationBar: NavigationBar(
              //   destinations: [
              //     const NavigationDestination(
              //         icon: Icon(Icons.home_rounded), label: 'Home'),
              //     NavigationDestination(
              //         icon: Icon(
              //           Icons.date_range_sharp,
              //           color: Colors.green.shade300,
              //         ),
              //         label: 'Schedule'),
              //     const NavigationDestination(
              //         icon: Icon(Icons.settings), label: 'Settings'),
              //   ],
              //   selectedIndex: currentPageIndex,
              //   onDestinationSelected: (int index) {
              //     //needs to implement bloc here and remove setState
              //     setState(
              //       () {
              //         currentPageIndex = index;
              //       },
              //     );
              //   },
              // ),
            ),
          ),
        );
      },
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context, Colors.red.shade300);
    }

    if (state.stateStatus == StateStatus.initial) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider<AuthBloc>(
              create: (context) => diContainer.authBloc,
              child: const LoginPage(),
            ),
          ),
          ModalRoute.withName('/'));
    }
  }

  void _searchDoctor(BuildContext context, String name) {
    _authBloc.add(SearchDoctorEvent(name: name));
  }

  Future<void> _pullRefresh() async {
    _authBloc.add(GetDoctorEvent());
    _authBloc.add(AuthAutoLoginEvent());
  }
}
