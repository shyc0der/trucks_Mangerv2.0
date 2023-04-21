import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

Future<OrderWidgateState?> changeDialogState() async {
  return await Get.dialog<OrderWidgateState>(Dialog(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Set state to:'),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.back(result: OrderWidgateState.Declined);
                },
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text('Declined'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent)),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Get.back(result: OrderWidgateState.Approved);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text('Approve')),
            ],
          ),
        ],
      ),
    ),
  ));
}

Future<OrderWidgateState?> changeDialogStateJob(OrderWidgateState getJobState,
    {bool isSuperUser = false,
    bool isDriver = false,
    bool isExpenseApproved = false,
    bool isJob = true}) async {
  return await Get.dialog<OrderWidgateState?>(Dialog(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((isJob && isExpenseApproved == false) || !isJob)
            const Text('Set state to:'),
          if (isJob && isExpenseApproved == true)
            const Text(
              'WARNING',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isJob && isExpenseApproved == true)
                Column(
                  children: [
                    const Text(
                      'PLEASE APPROVE AND CLOSE ALL EXPENSES BEFORE CLOSING THE JOB',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: const Text('OK'),
                    ),
                  ],
                ),

              // if expense and admin or is job & is driver
              if (isJob && isExpenseApproved == false || (!isJob))
                if (((!isJob && isSuperUser) &&
                        (getJobState == OrderWidgateState.Pending ||
                            getJobState == OrderWidgateState.Open)) ||
                    (isJob &&
                        (getJobState == OrderWidgateState.Approved ||
                            getJobState == OrderWidgateState.Pending ||
                            getJobState == OrderWidgateState.Open)))
                  //if (isJob)

                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back(result: OrderWidgateState.Rejected);
                    },
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Reject'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                  ),

              // if expense and admin or is job & is driver
              // if((!isJob && isSuperUser) || (isJob && isDriver))
              //if ((!isJob && isSuperUser) || (isJob))
              if ((isJob))
                if ((getJobState == OrderWidgateState.Pending ||
                        getJobState == OrderWidgateState.Approved) ||
                    getJobState == OrderWidgateState.Rejected)
                  ElevatedButton.icon(
                      onPressed: () {
                        Get.back(result: OrderWidgateState.Open);
                      },
                      icon: const Icon(Icons.done),
                      label: const Text('Open')),

              if (!isJob && isSuperUser)
                if ((getJobState == OrderWidgateState.Pending ||
                        getJobState == OrderWidgateState.Open) ||
                    getJobState == OrderWidgateState.Rejected)
                  ElevatedButton.icon(
                      onPressed: () {
                        Get.back(result: OrderWidgateState.Approved);
                      },
                      icon: const Icon(Icons.done),
                      label: const Text('Approve')),

              // Closed for driver
              if (isJob && isExpenseApproved == false || (!isJob))
                if ((isJob && getJobState == OrderWidgateState.Open) ||
                    (!(isJob &&
                        (getJobState == OrderWidgateState.Rejected ||
                            getJobState == OrderWidgateState.Approved))))
                  ElevatedButton.icon(
                    onPressed: () {
                      print(getJobState);
                      Get.back(result: OrderWidgateState.Closed);
                      isExpenseApproved = false;
                    },
                    icon: const Icon(Icons.done_all),
                    label: Text('Close ${isJob ? "Job" : "Expense"}'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
            ],
          ),
        ],
      ),
    ),
  ));
}
