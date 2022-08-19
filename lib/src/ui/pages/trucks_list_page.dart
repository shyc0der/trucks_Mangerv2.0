import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/pages/truck_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

class TrucksListPage extends StatelessWidget {
 TrucksListPage({Key? key}) : super(key: key);
  final TruckModules _truckModules = TruckModules();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: StreamBuilder<List<TrucksModel?>>(
            stream: _truckModules.fetchTrucks(),
            builder: (context, snapshot) {
              var trucks=snapshot.data ?? [];
              return Wrap(
                children: [
                  for (var truck in trucks)
                    ItemCardWidget(
                      label: truck?.vehicleRegNo ?? '',
                      iconData: Icons.local_shipping_outlined,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>  TruckDetailsPage(truck)));
                      },
                    )
                ],
              );
            }),
      ),
    );
  }
}
