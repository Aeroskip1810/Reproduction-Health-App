import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/appoinment/view_models/appoinment_view_model.dart';
import 'package:reprohealth_app/screen/appoinment/widget/klinik_appoinment_widget.dart';
import 'package:reprohealth_app/screen/appoinment/widget/location_appoinment_view.dart';
import 'package:reprohealth_app/screen/appoinment/widget/spesialis_appointment_widget.dart';
import 'package:reprohealth_app/screen/appoinment/widget/text_field_appointment_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class AppoinmentView extends StatefulWidget {
  const AppoinmentView({super.key});

  @override
  State<AppoinmentView> createState() => _AppoinmentViewState();
}

class _AppoinmentViewState extends State<AppoinmentView> {

  @override
  void initState() {
    Provider.of<AppoinmentViewModel>(context, listen: false).getClinicsList();
    Provider.of<AppoinmentViewModel>(context, listen: false).getLocation();
    Provider.of<AppoinmentViewModel>(context, listen: false)
        .getSpecialistList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: Image(
            width: 129.0,
            height: 40.0,
            image: AssetImage(Assets.assetsLogoReproHealthAppoinment),
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: IconButton(
              color: green500,
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.pushNamed(context, RoutesNavigation.notificationView);
              },
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: grey10,
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LocationAppoinmentWidget(),
            TextFieldAppointmentWidget(),
            SpesialisAppoinmentWidget(),
            KlinikAppoinmentWidget(),
          ],
        ),
      ),
    );
  }
}
