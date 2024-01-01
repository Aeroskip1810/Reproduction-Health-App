import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/appointment_models/appointment_models.dart';
import 'package:reprohealth_app/services/appointment_services/appointment_services.dart';
import 'package:reprohealth_app/services/payment_services/payment_services.dart';
import 'package:reprohealth_app/theme/theme.dart';

class PaymentViewModel extends ChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _rekController = TextEditingController();
  TextEditingController get rekController => _rekController;

  final AppointmentServices _appointmentServices = AppointmentServices();
  AppoinmentModels? _appointmentList;
  AppoinmentModels? get appointmentList => _appointmentList;

  final ImagePicker _imagePicker = ImagePicker();
  ImagePicker get imagePicker => _imagePicker;
  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedBank = '';
  String get selectedBank => _selectedBank;

  final List<String> banks = [
    'BCA',
    'BNI',
    'Mandiri',
    'CIMB Niaga',
    'Danamon',
    'Maybank',
    'Mestika'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _rekController.dispose();
    super.dispose();
  }

  void selectBank(index) {
    _selectedBank = banks[index];
    _isExpanded = false;
    notifyListeners();
  }

  void isExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  bool validateName(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  bool validateRekening(String value) {
    if (value.isEmpty || value.isEmpty) {
      return false;
    } else if (value.length < 8) {
      return false;
    }
    return true;
  }

  Future<void> getTransactions({required String patientId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointmentList =
          await _appointmentServices.getTransactions(patientId: patientId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> showImagePicker({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Foto',
                  style: semiBold16Black,
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    _handlePickedImage(pickedFile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Ambil Foto',
                      style: regular14Grey900,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    _handlePickedImage(pickedFile);
                  },
                  child: Text(
                    'Pilih dari Galeri',
                    style: regular14Grey900,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _handlePickedImage(XFile? pickedFile) {
    if (pickedFile != null) {
      _pickedImage = pickedFile;
      notifyListeners();
    }
  }

  Future<void> createPayment({
    required BuildContext context,
    required String idTransaction,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      XFile imageFile = XFile(_pickedImage!.path);

      await PaymentServices().createPayment(
        idTransaction: idTransaction,
        name: _nameController.text,
        accountNumber: _rekController.text,
        image: imageFile,
      );

      _nameController.clear();
      _selectedBank = '';
      _rekController.clear();
      _pickedImage == null;

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNavigation.confirmSplashView,
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
