import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/screen/profile/view_model/change_gender_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/get_family_profile_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/post_family_profile_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/put_family_profile_view_model.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/button_widget.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/change_data_profile_view.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/snackbar_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ChangeProfileView extends StatefulWidget {
  final String? idPatients;
  final String? date;
  final String? gender;
  final String? nameController;
  final String? nomorController;
  final num? beratController;
  final num? tinggiController;
  const ChangeProfileView(
      {super.key,
      this.idPatients,
      this.date,
      this.nameController,
      this.nomorController,
      this.beratController,
      this.tinggiController,
      this.gender});

  @override
  State<ChangeProfileView> createState() => _ChangeProfileViewState();
}

class _ChangeProfileViewState extends State<ChangeProfileView> {
  late String idPatients;
  late String gender;
  late TextEditingController nameController;
  late TextEditingController nomorController;
  late TextEditingController beratController;
  late TextEditingController tinggiController;
  late TextEditingController dateController;

  late final PutFamilyProfileViewModel updateProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    idPatients = widget.idPatients ?? "";
    dateController = TextEditingController(text: widget.date ?? "");
    gender = widget.gender ?? "";
    nameController = TextEditingController(text: widget.nameController);
    nomorController = TextEditingController(text: widget.nomorController);
    beratController =
        TextEditingController(text: widget.beratController?.toString());
    tinggiController =
        TextEditingController(text: widget.tinggiController?.toString());
    Provider.of<GetFamilyProfileViewModel>(context, listen: false)
        .fetchProfileDataId(context: context, idPatients: idPatients);
  }

  @override
  void dispose() {
    nameController.dispose();
    nomorController.dispose();
    dateController.dispose();
    beratController.dispose();
    tinggiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postFamilyProfile = Provider.of<PostFamilyProfileViewModel>(context);
    final changeGenderViewModel = Provider.of<ChangeGenderViewModel>(context);
    changeGenderViewModel.groupValue.value = gender;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffE9E9E9),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: grey10,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: secondary,
              ),
              onPressed: () {
                Navigator.pop(context);
                changeGenderViewModel.groupValue.value = "";
              },
            ),
            titleSpacing: 0,
            title: Text('Ubah Data Pribadi',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                    ChangeDataProfile(
                      controller1: nameController,
                      controller2: nomorController,
                      controller3: beratController,
                      controller4: tinggiController,
                      dateController: dateController,
                      onChanged: (String? value) {
                        changeGenderViewModel.groupValue.value = value ?? "";
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ButtonWidget(
                        title: "Simpan",
                        onPressed: () {
                          var updateProvider =
                              Provider.of<PutFamilyProfileViewModel>(context,
                                  listen: false);
                          String formattedDate =
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
                                  DateFormat('dd/MM/yyyy')
                                      .parse(dateController.text)
                                      .toLocal());
                          if (_formKey.currentState!.validate()) {
                            updateProvider.updateProfileData(
                                context: context,
                                idPatients: idPatients,
                                name: nameController.text,
                                nomor: nomorController.text,
                                gender: changeGenderViewModel.groupValue.value,
                                date: formattedDate,
                                berat: num.parse(beratController.text),
                                tinggi: num.parse(tinggiController.text));
                            postFamilyProfile.nameController.clear();
                            postFamilyProfile.nomorController.clear();
                            postFamilyProfile.beratController.clear();
                            postFamilyProfile.tinggiController.clear();
                            changeGenderViewModel.groupValue.value = "";
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(CustomSnackBar(
                              contentText: 'Profil berhasil diubah!',
                              backgroundColor: positive,
                            ));
                          }
                        },
                        color: green500),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
