import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/screen/profile/view_model/change_gender_view_model.dart';
import 'package:reprohealth_app/screen/profile/view_model/date_picker_view_model.dart';
import 'package:reprohealth_app/screen/profile/widget/profile_widget/text_field_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class ChangeDataProfile extends StatelessWidget {
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  final TextEditingController? controller3;
  final TextEditingController? controller4;
  final TextEditingController? dateController;
  final Function(String?)? onChanged;

  const ChangeDataProfile({
    Key? key,
    this.controller1,
    this.controller2,
    this.controller3,
    this.controller4,
    this.dateController,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datePickerProvider = Provider.of<DatePickerViewModel>(context);
    final changeGenderViewModel = Provider.of<ChangeGenderViewModel>(context);
    
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          height: 495,
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAFA),
            ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    controller: controller1,
                    hintText: "Nama Lengkap",
                    label: "Nama Lengkap",
                    validator: (value) {
                    if (value == null || value.isEmpty || !value.contains(RegExp(r'[a-z]'))) {
                      return 'Masukkan Nama!';
                    }
                    return null;
                  },
                ),
                  const SizedBox(height: 16,),
                  TextFieldWidget(
                    controller: controller2, 
                    hintText: "Nomor Ponsel",
                    label: "Nomor Ponsel",
                    textInputType: TextInputType.number,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Nomor Ponsel!';
                    } else if (value.length >= 15 || value.length <= 8 || !value.contains(RegExp(r'[0-9]')) || value.contains(RegExp(r'[a-z]')) || value.contains(RegExp(r'[A-Z]'))) {
                      return 'Nomor ponsel tidak valid!';
                    }
                    return null;
                  },
                    ),
                  const SizedBox(height: 16,),
                  Text("Tanggal Lahir",
                  style: regular12Grey500,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final selectDate = await showDatePicker(
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                              primary: green500,
                              onPrimary: Colors.white,
                              onSurface: grey500,
                              surface: grey5
                            ),
                            dialogTheme: const DialogTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)))),
                            dialogBackgroundColor: grey5,
                            ),
                            child: child!
                          );
                        },
                        locale: const Locale('id'),
                        initialDate: datePickerProvider.currentDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now()
                        );
                        if (selectDate != null) {
                          datePickerProvider.dueDate = selectDate;
                          dateController?.text = DateFormat('dd/MM/yyyy', 'id_ID').format(selectDate);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: grey500
                        ),
                        borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            dateController?.text ?? "",
                            style: regular12Grey500,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_month,
                            color: green500,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text("Jenis Kelamin",
                  style: regular12Grey500,
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: changeGenderViewModel.groupValue,
                        builder: (context, value, _) {
                          return Container(
                            width: 16,
                            margin: const EdgeInsets.only(right: 8),
                            child: Radio(
                              fillColor: MaterialStateProperty.all(green500),
                              value: "male",
                              groupValue: value,
                              onChanged: onChanged
                            ),
                          );
                        },
                      ),
                      Text("Laki - laki",
                      style: regular12Grey500,
                      ),
                      const SizedBox(width: 16),
                      ValueListenableBuilder<String>(
                        valueListenable: changeGenderViewModel.groupValue,
                        builder: (context, value, _) {
                          return Container(
                            width: 16,
                            margin: const EdgeInsets.only(right: 8),
                            child: Radio(
                              fillColor: MaterialStateProperty.all(green500),
                              value: "female",
                              groupValue: value,
                              onChanged: onChanged
                            ),
                          );
                        },
                      ),
                      Text("Perempuan",
                      style: regular12Grey500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextFieldWidget(
                    controller: controller3,
                    hintText: "Berat Badan",
                    label: "Berat Badan",
                    textInputType: TextInputType.number,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan berat badan!';
                    } else if (value.contains(RegExp(r'[!\"#$%&*+\-/()]+')) || !value.contains(RegExp(r'[0-9]')) || value.contains(RegExp(r'[a-z]')) || value.contains(RegExp(r'[A-Z]'))|| num.parse(value) >= 300) {
                      return 'Data yang dimasukkan tidak valid!';
                    }
                    return null;
                  },
                    ),
                  const SizedBox(height: 16,),
                  TextFieldWidget(
                    controller: controller4,
                    hintText: "Tinggi Badan",
                    label: "Tinggi Badan",
                    textInputType: TextInputType.number,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan tinggi badan!';
                    } else if (value.contains(RegExp(r'[!\"#$%&*+,\-./()]+')) || !value.contains(RegExp(r'[0-9]')) || value.contains(RegExp(r'[a-z]')) || value.contains(RegExp(r'[A-Z]'))|| int.parse(value) >= 300) {
                      return 'Data yang dimasukkan tidak valid!';
                    }
                    return null;
                  },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
