import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_items_widget.dart';

class JobDetailPage extends StatelessWidget {
  JobDetailPage(this.job, {Key? key}) : super(key: key);
  final JobModel job;

  final TruckModules _truckModules = TruckModules();
  final OrderModules _orderModules = OrderModules();
  final UserModule _userModule = UserModule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Jobs Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // order detail
            FutureBuilder<OrderModel>(
                future: _orderModules.fetchFutureOrderById(job.orderId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return OrderDetialWidget(
                      title: snapshot.data!.title ?? '',
                      amount: 'Ksh. ${snapshot.data!.amount?.ceilToDouble()}',
                      date: snapshot.data!.dateCreated
                          .toString()
                          .substring(0, 16),
                      orderState: snapshot.data!.orderStates,
                      onApprove: () {},
                      onCancel: () {},
                      onClose: () {},
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),

            const SizedBox(
              height: 20,
            ),

            // driver detail
            if (job.jobStates != OrderWidgateState.Pending)
              FutureBuilder<UserModel>(
                  future: _userModule.fetchTruckByUser(job.driverId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Driver Not Found'),
                      );
                    }
                    if (snapshot.hasData) {
                      return OrderItemsDriverWidget(
                        driverName:
                            '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                        email: snapshot.data?.email ?? '',
                        phoneNo: snapshot.data?.phoneNo ?? '',
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

            // Truck detail
            if (job.jobStates != OrderWidgateState.Pending)
              FutureBuilder<TrucksModel>(
                  future: _truckModules.fetchFutureJobsPerTruck(job.vehicleId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error : Truck Not Found}');
                    }
                    if (snapshot.hasData) {
                      var snaps = snapshot.data!;
                      return OrderItemsTruckWidget(
                        registration: snaps.vehicleRegNo ?? '',
                        loadCapacity: snaps.tankCapity ?? '',
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
          ],
        ),
      ),
    );
  }
}
