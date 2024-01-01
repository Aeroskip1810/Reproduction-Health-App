import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/services/forum_services/forum_services.dart';
import 'package:reprohealth_app/theme/theme.dart';

class CreateForumViewModel extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get messageController => _messageController;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Color _buttonColor = grey100;
  Color get buttonColor => _buttonColor;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.clear();
    super.dispose();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void updateButtonColor() {
    _buttonColor =
        (titleController.text.isEmpty || messageController.text.isEmpty)
            ? grey100
            : green500;
    notifyListeners();
  }

  void initController() {
    _titleController.addListener(updateButtonColor);
    _messageController.addListener(updateButtonColor);
  }

  Future<void> createForum({
    required String patientId,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ForumServices().createForum(
        patientId: patientId,
        title: _titleController.text,
        content: _messageController.text,
        anonymous: _rememberMe,
        context: context,
      );

      _titleController.clear();
      _messageController.clear();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNavigation.homeView,
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Kendala: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
