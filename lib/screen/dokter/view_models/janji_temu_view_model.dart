import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/appointment_models/appointment_models.dart';
import 'package:reprohealth_app/models/doctor_models/doctor_models.dart';
import 'package:reprohealth_app/models/profile_models/profile_models.dart';
import 'package:reprohealth_app/services/appointment_services/appointment_services.dart';
import 'package:reprohealth_app/services/profile_service/profile_service.dart';
import 'package:reprohealth_app/theme/theme.dart';

class JanjiTemuViewModel extends ChangeNotifier {
  final AppointmentServices _appointmentServices = AppointmentServices();
  AppoinmentModels? _appointmentList;
  AppoinmentModels? get appointmentList => _appointmentList;

  final ProfileService _profileServices = ProfileService();
  ProfileModel? _profileList;
  ProfileModel? get profileList => _profileList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _id;
  String? get id => _id;

  List<String> listPaymentMethod = [
    "clinic_payment",
    "manual_transfer",
  ];

  String _selectedPayment = '';
  String get selectedPayment => _selectedPayment;
  set setSelectedPayment(String newPayment) {
    _selectedPayment = newPayment;
    notifyListeners();
  }

  void saveId(String idConsultasion) {
    _id = idConsultasion;
    notifyListeners();
  }

  // PILIH SESI
  List<String> sessions = [
    "pagi",
    "siang",
    "malam",
  ];

  //^ SET selectionSession
  // [SESI] rescedhule yang dipilih oleh user
  String _selectedSession = '';
  String get selectedSession => _selectedSession;
  set setSelectedSession(String newSession) {
    notifyListeners();
    _selectedSession = newSession;
  }

  // PILIH TANGGAL
  DateTime _currentDate = DateTime.now();
  DateTime get currentDate => _currentDate;
  DateTime _dueDate = DateTime.now();
  DateTime get dueDate => _dueDate;

  set dueDate(DateTime value) {
    _dueDate = value;
    notifyListeners();
  }

  set currentDate(DateTime value) {
    _currentDate = value;
    notifyListeners();
  }

  Future<void> getTransactions({required String patientId}) async {
    try {
      _appointmentList =
          await _appointmentServices.getTransactions(patientId: patientId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getProfile({required BuildContext context}) async {
    try {
      _profileList = await _profileServices.getProfileModel(context: context);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> postConsultasion({
    required String patientId,
    required String doctorId,
    required DateTime date,
    required String session,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final id = await AppointmentServices().postConsultasion(
        paymentMethod: _selectedPayment,
        patientId: patientId,
        doctorId: doctorId,
        date: date,
        session: session,
        context: context,
      );

      if (context.mounted) {
        if (id.isNotEmpty == true) {
          if (_selectedPayment == "clinic_payment") {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesNavigation.homeView,
              (route) => route.isFirst,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              RoutesNavigation.paymentMethodView,
              arguments: IdArgument(
                idTransaction: id,
                idProfile: patientId,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        if (_selectedPayment.isNotEmpty == true) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    'Dokter tidak tersedia',
                    style: semiBold14Black,
                    textAlign: TextAlign.center,
                  ),
                ),
                content: Text(
                  'Silahkan memilih tanggal lain untuk dapat melakukan janji temu dengan dokter!!',
                  style: regular12Grey300,
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  SizedBox(
                    height: 36,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Ok',
                        style: semiBold12Grey10,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    'Metode pembayaran tidak tersedia',
                    style: semiBold14Black,
                    textAlign: TextAlign.center,
                  ),
                ),
                content: Text(
                  'Silahkan memilih metode pembayaran untuk dapat melakukan janji temu dengan dokter!!',
                  style: regular12Grey300,
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  SizedBox(
                    height: 36,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Ok',
                        style: semiBold12Grey10,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class IdArgument {
  final String? idTransaction;
  final String? idProfile;

  IdArgument({required this.idTransaction, required this.idProfile});
}

class ArgumentDoctor {
  final ResponseDataDoctor? dataDoctor;
  final ResponseDataProfile? dataProfile;

  ArgumentDoctor({
    required this.dataDoctor,
    required this.dataProfile,
  });
}
