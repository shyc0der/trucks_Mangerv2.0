// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/jobs/jobs_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/constants.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../../modules/user_modules.dart';

class JobsPage extends StatefulWidget {
  JobsPage(this.state, {Key? key}) : super(key: key);
  String state;

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final JobModule _jobModule = JobModule();
  final OrderModules orderModules = Get.put<OrderModules>(OrderModules());
  final UserModule userModule = Get.put(UserModule());
  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');

  String? fetchOrder(String? orderId) {
    var res = orderModules.getOrderByJobId(orderId!);

    return res?.title;
  }

  double? fetchAmount(String? orderId) {
    var res = orderModules.getOrderByJobId(orderId!);

    return res?.amount;
  }

  // void _changeView(int val) {
  //   switch (val) {
  //     case 1:
  //       setState(() {
  //         displayJobs = displayJob
  //             .where(
  //                 (element) => element.jobStates == OrderWidgateState.Pending)
  //             .toList();
  //       });
  //       break;
  //     case 2:
  //       setState(() {
  //         displayJobs = displayJob
  //             .where((element) => element.jobStates == OrderWidgateState.Open)
  //             .toList();
  //       });
  //       break;
  //     case 3:
  //       setState(() {
  //         displayJobs = displayJob
  //             .where((element) => element.jobStates == OrderWidgateState.Closed)
  //             .toList();
  //       });
  //       break;
  //     default:
  //       setState(() {
  //         displayJobs = displayJob;
  //       });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Constants constants = Constants();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Jobs'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: StreamBuilder<List<JobModel>>(
            stream: _jobModule.fetchJobsByState(
                widget.state, userModule.currentUser.value),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error = ${snapshot.error}');
              }
              if (snapshot.hasData) {
                var displayJobs = snapshot.data!;
                return ListView.builder(
                  itemCount: displayJobs.length,
                  itemBuilder: (_, index) {
                    return JobListTile(
                      title: constants.fetchOrder(displayJobs[index].orderId) ??
                          '',
                      orderNo:
                          constants.truckNumber(displayJobs[index].vehicleId!),
                      dateTime: displayJobs[index].dateCreated,
                      amount: doubleFormat.format(
                          (fetchAmount(displayJobs[index].orderId) ?? 0)
                              .ceilToDouble()),
                      jobState: displayJobs[index].jobStates,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => JobDetailPage(displayJobs[index])));
                      },
                    );
                  },
                );
              }
              else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
            }));
    //   bottomNavigationBar: BottomNavigationBar(
    //     type: BottomNavigationBarType.fixed,
    //     onTap: _changeView,
    //     currentIndex: 0,
    //     items: const [
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.list_outlined), label: 'All'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.outbox_outlined), label: 'Pending'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.outbox_outlined), label: 'Open'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.done_all_outlined), label: 'Closed'),
    //     ],
    //   ),
    // );
  }
}
