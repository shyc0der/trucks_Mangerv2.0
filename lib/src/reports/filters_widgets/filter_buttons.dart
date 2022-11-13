import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/reports/reports_generator_module.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({this.onFilter, Key? key }) : super(key: key);
  final ReportGeneratorModule Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // cancel
        TextButton(
          onPressed: ()=> Get.back(), 
          child: const Text('Cancel')
        ),

        // filter
        ElevatedButton(
          onPressed: onFilter == null ? null : (){
            Get.back(result: onFilter?.call());
          }, 
          child: const Text('Filter')
        )
      ],
    );
  }
}