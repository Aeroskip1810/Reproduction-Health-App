import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';

import 'package:reprohealth_app/models/riwayat_models/history_transaction_models.dart';
import 'package:reprohealth_app/screen/riwayat/view_model/riwayat_view_model.dart';
import 'package:reprohealth_app/screen/riwayat/widget/appointment_list_item_widget.dart';
import 'package:reprohealth_app/theme/theme.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({
    super.key,
    required this.transactionData,
  });

  final List<ResponseData> transactionData;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = Provider.of<RiwayatViewModel>(context);

    return RefreshIndicator(
      onRefresh: () => controller.onRefresh(),
      color: green500,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: transactionData.isNotEmpty == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactionData.length,
                      itemBuilder: (context, index) {
                        var appointmentData = transactionData[index];

                        return AppointmentListItemWidget(
                          appointmentData: appointmentData,
                          visibleStatusContainer:
                              controller.visibleStatusContainer(
                            status: appointmentData.status ?? '-',
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RoutesNavigation.appointmentHistoryDetailView,
                              arguments: appointmentData,
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      width: size.width,
                      height: size.height,
                      color: grey10,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.assetsEmptyTransactions,
                            height: 180,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Anda belum melakukan transaksi',
                            style: semiBold14Grey400,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
