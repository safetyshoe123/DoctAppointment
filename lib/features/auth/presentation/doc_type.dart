import 'package:bookme_up/core/dependency_injection/di_container.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/core/global_widgets/snackbar_widget.dart';
import 'package:bookme_up/core/utils/docpics.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/presentation/doc_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class DocType extends StatefulWidget {
  const DocType({super.key, required this.doctype, required this.patientName});
  final String doctype;
  final String patientName;

  @override
  State<DocType> createState() => _DocTypeState();
}

class _DocTypeState extends State<DocType> {
  final DIContainer diContainer = DIContainer();
  late String _doctype;
  late AuthBloc _authBloc;
  late String _patientName;
  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _doctype = widget.doctype;
    _authBloc.add(SpecificDoctorEvent(docType: _doctype));
    _patientName = widget.patientName;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _authListener,
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      height: 200,
                      width: _doctype == 'Cardiology' ? 300 : 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _doctype == 'Cardiology'
                              ? const AssetImage('images/cardio.png')
                              : _doctype == 'Dentistry'
                                  ? const AssetImage('images/dentist3.png')
                                  : const AssetImage('images/oculist.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      _doctype == 'Cardiology'
                          ? 'Heart Treatment'
                          : _doctype == 'Dentistry'
                              ? 'Dental Service'
                              : 'Eye Treatment',
                      style: GoogleFonts.ubuntu(
                        color: const Color.fromARGB(218, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        shadows: [
                          const Shadow(
                            color: Color.fromARGB(148, 27, 94, 31),
                            offset: Offset(2, 3),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: screenSize.height / 1.7,
                  width: screenSize.width,
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
                    child: Builder(builder: (context) {
                      if (state.isEmpty == true) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  'No doctors is listed in this field!',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.docModel.length,
                        itemBuilder: (context, index) {
                          final docPicsList = DoctorPics.arrayPics[index];
                          final docList = state.docModel[index];
                          return Card(
                            color: HexColor('#e8f7ee'),
                            shadowColor: Colors.green.shade800,
                            elevation: 7,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox.square(
                                  dimension: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        filterQuality: FilterQuality.medium,
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
                                                  create:
                                                      (BuildContext context) =>
                                                          diContainer.authBloc,
                                                  child: DocProfile(
                                                    doctorsModel: docList,
                                                    index: index,
                                                    patientName: _patientName,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Show more',
                                            style: TextStyle(fontSize: 12),
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
              ],
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
  }
}
