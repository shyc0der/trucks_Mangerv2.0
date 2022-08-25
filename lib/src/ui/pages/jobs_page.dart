import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/jobs_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  late Stream<List<JobModel>> jobs;
  late Stream<OrderModel> orders;
  late List<JobModel> displayJobs = [];
  late List<OrderModel> displayOrders = [];
  late OrderModel displayOrder = OrderModel();
  late List<JobModel> displayJob;
  final JobModule _jobModule = JobModule();
  final OrderModules orderModules = Get.put<OrderModules>(OrderModules());

  String? fetchOrder(String? orderId) {
    var res = orderModules.getOrderByJobId(orderId!);
    print(res?.title);
    return res?.title;
  }

  void _changeView(int val) {
    switch (val) {
      case 1:
        setState(() {
          displayJobs = displayJob
              .where((element) => element.jobStates == OrderWidgateState.Open)
              .toList();
        });
        break;
      case 2:
        setState(() {
          displayJobs = displayJob
              .where((element) => element.jobStates == OrderWidgateState.Closed)
              .toList();
        });
        break;
      default:
        setState(() {
          displayJobs = displayJob;
        });
    }
  }

  @override
  void initState() {
    super.initState();

    jobs = _jobModule.fetchJobs();
    jobs.forEach((element) {
      setState(() {
        displayJob = element;
        displayJobs = displayJob;
        element.forEach((e) {
          orders = orderModules.fetchOrderById(e.orderId!);
          orders.forEach((orderElement) {
            setState(() {
              displayOrder = orderElement;
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Jobs'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView.builder(
        itemCount: displayJobs.length,
        itemBuilder: (_, index) {
          return JobListTile(
            title: displayJobs[index].orderNo ?? '',
            dateTime: displayJobs[index].dateCreated,
            amount: displayOrder.amount ?? 0,
            jobState: displayJobs[index].jobStates,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => JobDetailPage(displayJobs[index])));
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _changeView,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined), label: 'All'),
          BottomNavigationBarItem(
              icon: Icon(Icons.outbox_outlined), label: 'Open'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all_outlined), label: 'Closed'),
        ],
      ),
    );
  }
}
