import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/core/global_widgets/snackbar_widget.dart';
import 'package:bookme_up/core/utils/docpics.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:bookme_up/features/auth/domain/models/add_date_model.dart';
import 'package:bookme_up/features/auth/domain/models/doctors.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class DocProfile extends StatefulWidget {
  const DocProfile({
    super.key,
    required this.doctorsModel,
    required this.index,
    required this.patientName,
  });
  final DoctorsModel doctorsModel;
  final int index;
  final String patientName;

  @override
  State<DocProfile> createState() => _DocProfileState();
}

class _DocProfileState extends State<DocProfile> {
  late DoctorsModel _doctorsModel;
  late AuthBloc _authBloc;
  late int _index;
  late String _patientName;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _doctorsModel = widget.doctorsModel;
    _index = widget.index;
    _patientName = widget.patientName;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _listener,
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
              image: AssetImage('assets/images/green_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(forceMaterialTransparency: true),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Make an Appointment',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 26,
                    shadows: [
                      Shadow(
                        color: Colors.green.shade800,
                        offset: const Offset(
                          2,
                          3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenSize.height / 3,
                  width: screenSize.width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(DoctorPics.arrayPics[_index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: screenSize.height / 1.9,
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
                        horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Dr. ${_doctorsModel.docName}',
                          style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(228, 22, 22, 22),
                          ),
                        ),
                        Text(
                          _doctorsModel.specialization,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: const Color.fromARGB(228, 22, 22, 22),
                          ),
                        ),
                        Text(
                          _doctorsModel.description,
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: const Color.fromARGB(228, 22, 22, 22),
                              decorationStyle: TextDecorationStyle.solid),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 40,
                          width: 220,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade400,
                            ),
                            onPressed: () async {
                              _datePicker(context);
                            },
                            child: Text(
                              'Make an Appointment',
                              style: GoogleFonts.ubuntu(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context, Colors.red.shade300);
    }
    if (state.isAdded == true) {
      SnackBarUtils.defualtSnackBar('Appointment has been set!', context, Colors.green);
    }
  }

  Future<void> _datePicker(BuildContext context) async {
    DateTime? datepicker = await DatePicker.showSimpleDatePicker(
      context,
      pickerMode: DateTimePickerMode.datetime,
      firstDate: DateTime.timestamp(),
      lastDate: DateTime(2100),
      dateFormat: 'dd-MM-yyyy',
      locale: DateTimePickerLocale.en_us,
      looping: true,
      backgroundColor: Colors.white70,
    );

    if (mounted) {
      if (datepicker != null) {
        _addDateTime(context, datepicker);
      }
    }
  }

  void _addDateTime(BuildContext context, DateTime datepicker) {
    _authBloc.add(
      AddDateTimeEvent(
        addDateModel: AddDateModel(
          docName: _doctorsModel.docName,
          patientName: _patientName,
          schedule: datepicker,
        ),
      ),
    );
  }
}
