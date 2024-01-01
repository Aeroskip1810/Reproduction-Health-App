import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/profile/change_profile_view.dart';
import 'package:reprohealth_app/screen/profile/view_model/get_family_profile_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/image_picker_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/put_family_profile_view_model.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/bottom_sheet_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<GetFamilyProfileViewModel>(context, listen: false)
        .fetchProfileData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GetFamilyProfileViewModel>(context);
    return Scaffold(
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
          },
        ),
        titleSpacing: 0,
        title: Text(
          "Profil Saya",
          style: semiBold16Primary4,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await Provider.of<GetFamilyProfileViewModel>(context,
                      listen: false)
                  .fetchProfileData(context: context);
              final myProfile =
                  Provider.of<GetFamilyProfileViewModel>(context, listen: false)
                      .profileList
                      ?.response
                      ?.first;
              if (myProfile != null) {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeProfileView(
                        idPatients: myProfile.id,
                        date: DateFormat('dd/MM/yyyy')
                            .format(myProfile.dateOfBirth ?? DateTime.now()),
                        nameController: myProfile.name,
                        nomorController: myProfile.telephoneNumber,
                        beratController: myProfile.weight,
                        tinggiController: myProfile.height,
                        gender: myProfile.gender,
                      ),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pushNamed(
                    context,
                    RoutesNavigation.changeProfileView,
                  );
                }
              }
            },
            child: Text(
              "Ubah",
              style: semiBold16Green500,
            ),
          ),
        ],
      ),
      body: Consumer<GetFamilyProfileViewModel>(
        builder: (context, getFamilyProfileViewModel, child) {
          final myProfile =
              getFamilyProfileViewModel.profileList?.response?.isEmpty ?? true
                  ? null
                  : getFamilyProfileViewModel.profileList!.response!.first;

          final imagePicker =
              Provider.of<ImagePickerViewModel>(context, listen: false);
          if (imagePicker.file != null) {
            Future(() {
              Provider.of<PutFamilyProfileViewModel>(context, listen: false)
                  .updateProfileImage(
                imageFile: imagePicker.file,
                idPatients: myProfile?.id ?? "",
              );

              Provider.of<ImagePickerViewModel>(context, listen: false)
                  .clearResult();
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Container(
                  height: 92,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFAFAFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xFFB9B9B9),
                                  backgroundImage: myProfile?.profileImage !=
                                          null
                                      ? NetworkImage(myProfile!.profileImage!)
                                      : null,
                                ),
                              ),
                              Positioned(
                                left: 55,
                                top: 50,
                                child: Container(
                                  width: 25,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE8F9F6),
                                  ),
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      BottomSheetWidget.bottomSheet(context);
                                    },
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: green500,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myProfile?.name ?? "-",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E1E1E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                myProfile?.telephoneNumber ?? "-",
                                style: regular14Grey200,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  width: double.infinity,
                  height: 224,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFAFAFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Lahir",
                          style: regular12Grey200,
                        ),
                        Text(
                          myProfile?.dateOfBirth == null
                              ? "-"
                              : DateFormat('dd MMMM yyyy', "id_ID").format(
                                  myProfile?.dateOfBirth ?? DateTime.now()),
                          style: semiBold14Grey500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Jenis Kelamin",
                          style: regular12Grey200,
                        ),
                        Text(
                          myProfile?.gender == "male"
                              ? "Laki - laki"
                              : (myProfile?.gender == "female"
                                  ? "Perempuan"
                                  : "-"),
                          style: semiBold14Grey500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Berat (kg)",
                          style: regular12Grey200,
                        ),
                        Text(
                          myProfile?.weight.toString() ?? "-",
                          style: semiBold14Grey500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Tinggi (cm)",
                          style: regular12Grey200,
                        ),
                        Text(
                          myProfile?.height.toString() ?? "-",
                          style: semiBold14Grey500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
