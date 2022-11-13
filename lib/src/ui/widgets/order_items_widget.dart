import 'package:flutter/material.dart';

class OrderItemsDriverWidget extends StatelessWidget {
  const OrderItemsDriverWidget(
      {required this.driverName,
      required this.email,
      required this.phoneNo,
      Key? key})
      : super(key: key);
  final String driverName;
  final String email;
  final String phoneNo;

  @override
  Widget build(BuildContext context) {
    return _OrderItemsWidget(
        title: driverName, body: email, subTitle: phoneNo, isDriver: true,isJob: false);
  }
}

class OrderItemsTruckWidget extends StatelessWidget {
  const OrderItemsTruckWidget(
      {required this.registration, required this.loadCapacity, Key? key})
      : super(key: key);
  final String registration;
  final String loadCapacity;

  @override
  Widget build(BuildContext context) {
    return _OrderItemsWidget(
        title: registration, subTitle: loadCapacity, isDriver: false,isJob:false);
  }
}

class _OrderItemsWidget extends StatelessWidget {
  const _OrderItemsWidget(
      {required this.isDriver,
      required this.isJob,
      required this.title,
      required this.subTitle,
      this.body,
      Key? key})
      : super(key: key);
  final String title;
  final String subTitle;
  final String? body;
  final bool isDriver;
  final bool isJob;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Row(
        children: [
          // icon
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              isDriver ? Icons.person_outline : isJob ? Icons.work : Icons.local_shipping_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          // details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isDriver ? 'Driver:' : isJob ? 'Job' :'Truck',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (body != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    body!,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              Text(
                subTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OrderItemsJobWidget extends StatelessWidget {
  const OrderItemsJobWidget({required this.title, required this.amount,Key? key }) :super(key: key);
 final String title;
 final  String amount; 
  
  
  @override
  Widget build(BuildContext context) {
  return _OrderItemsWidget(
        title: title, subTitle: amount, isDriver: false,isJob: true,);
  }
  
  }

