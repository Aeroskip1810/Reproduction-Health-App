import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/component/button_component.dart';
import 'package:reprohealth_app/component/card_doctor_component.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/models/doctor_models/doctor_models.dart';
import 'package:reprohealth_app/screen/dokter/view_models/janji_temu_view_model.dart';
import 'package:reprohealth_app/screen/dokter/widget/pilih_sesi_widget.dart';
import 'package:reprohealth_app/screen/dokter/widget/pilih_tanggal_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class JadwalDokterView extends StatefulWidget {
  const JadwalDokterView({Key? key}) : super(key: key);

  @override
  State<JadwalDokterView> createState() => JadwalDokterViewState();
}

class JadwalDokterViewState extends State<JadwalDokterView> {
  late int selectedPemesan;

  @override
  void initState() {
    super.initState();
    selectedPemesan = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      Provider.of<JanjiTemuViewModel>(context, listen: false)
          .getProfile(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ResponseDataDoctor?;
    final ResponseDataDoctor? detailDoctor = args;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey10,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.5),
          child: Text(
            'Jadwalkan',
            style: semiBold16Grey500,
          ),
        ),
        iconTheme: IconThemeData(color: primary4),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        children: [
          const SizedBox(
            height: 24,
          ),

          CardDoctorComponent(
            imageUrl: detailDoctor?.profileImage ?? '',
            doctorName: detailDoctor?.name ?? '',
            doctorSpecialist: detailDoctor?.specialist?.name ?? '',
            clinicsName: detailDoctor?.clinic?.name ?? '',
            doctorPrice: detailDoctor?.price ?? 0,
          ),

          const SizedBox(
            height: 24,
          ),

          // Form Pilih Tanggal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Tanggal',
                style: semiBold14Grey900,
              ),
              const SizedBox(
                height: 16,
              ),

              //  Pilih Tanggal
              const PilihTanggalWidget(),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Pilih Sesi',
                style: semiBold14Grey900,
              ),
              const SizedBox(
                height: 16,
              ),

              // Form Pilih Sesi
              const PilihSesiWidget(),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          // Button Component
          ButtonComponent(
            labelText: Text(
              "Lanjut ke Data Pemesanan",
              style: semiBold12Grey10,
              textAlign: TextAlign.center,
            ),
            backgroundColor: green500,
            onPressed: () {
              if (Provider.of<JanjiTemuViewModel>(context, listen: false)
                      .profileList
                      ?.response
                      ?.isNotEmpty ==
                  true) {
                // Bottom Sheet
                if (Provider.of<JanjiTemuViewModel>(context, listen: false)
                        .selectedSession
                        .isNotEmpty ==
                    true) {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Consumer<JanjiTemuViewModel>(
                                builder: (context, janjiTemuViewModel, child) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(
                                          'Pilih Profile Pasien',
                                          style: semiBold14Grey900,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 18),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: janjiTemuViewModel
                                              .profileList?.response?.length,
                                          itemBuilder: (context, int index) {
                                            final patientFamily =
                                                janjiTemuViewModel.profileList
                                                    ?.response?[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedPemesan = index;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      patientFamily?.name ?? '',
                                                      style: regular12Grey900,
                                                    ),
                                                    Radio(
                                                      activeColor: green500,
                                                      value: index,
                                                      groupValue:
                                                          selectedPemesan,
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            selectedPemesan =
                                                                value as int;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 36,
                                        ),
                                        // Button Component
                                        ButtonComponent(
                                          labelText: Text(
                                            "Selanjutnya",
                                            style: semiBold12Grey10,
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: green500,
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              RoutesNavigation.janjiTemuView,
                                              arguments: ArgumentDoctor(
                                                dataDoctor: detailDoctor,
                                                dataProfile: janjiTemuViewModel
                                                        .profileList?.response?[
                                                    selectedPemesan],
                                              ),
                                            );
                                            if (kDebugMode) {
                                              print(janjiTemuViewModel
                                                  .profileList
                                                  ?.response?[selectedPemesan]
                                                  .id);
                                              print(detailDoctor?.id);
                                              print(janjiTemuViewModel.dueDate);
                                              print(janjiTemuViewModel
                                                  .selectedSession);
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
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
                            'Data sesi kosong',
                            style: semiBold14Black,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        content: Text(
                          'Dimohon untuk mengisi kolom sesi untuk dapat membuat janji temu dengan dokter!!.',
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
                              child: Text('Kembali', style: semiBold12Grey10),
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
              } else {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          'Data Pasien Kosong',
                          style: semiBold14Black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      content: Text(
                        'Untuk dapat melakukan janji temu dengan dokter, buat data pasien baru pada menu profile terlebih dahulu!!.',
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
                              backgroundColor: negative,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Kembali', style: semiBold12Grey10),
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
            },
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
