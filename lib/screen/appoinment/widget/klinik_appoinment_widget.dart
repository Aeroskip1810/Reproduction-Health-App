import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/appoinment/view_models/appoinment_view_model.dart';
import 'package:reprohealth_app/theme/theme.dart';

class KlinikAppoinmentWidget extends StatelessWidget {
  const KlinikAppoinmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Berdasarkan Klinik',
                style: semiBold14Grey900,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesNavigation.klinikView,
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: regular12PrimaryGreen500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<AppoinmentViewModel>(
            builder: (context, appoinmentViewModel, child) {
              final filteredClinicsData =
                  appoinmentViewModel.filteredClinicsList;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: filteredClinicsData.length.clamp(0, 2),
                itemBuilder: (BuildContext context, int index) {
                  final clinics = filteredClinicsData[index];
                  appoinmentViewModel.getDistance(index: index);
                  return GestureDetector(
                    onTap: () {
                      print(appoinmentViewModel.distance);
                      Navigator.pushNamed(
                        context,
                        RoutesNavigation.detailKlinikView,
                        arguments: clinics,
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: clinics.image ?? '',
                                  width: 154,
                                  height: 80,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.error,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clinics.name ?? '',
                                  style: semiBold14Grey900,
                                ),
                                Text(
                                  clinics.location ?? '',
                                  style: regular10Grey900,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 10,
                                      color: green500,
                                    ),
                                    Text(
                                      appoinmentViewModel.distance == null
                                      ? "0 km"
                                      :"${(appoinmentViewModel.distance! / 1000).toStringAsFixed(1) } km",
                                      style: regular8Grey400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
