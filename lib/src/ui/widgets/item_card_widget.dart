import 'package:flutter/material.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({this.count, required this.iconData,required this.label, this.onTap, this.onLongPress, Key? key}) : super(key: key);
  final int? count;
  final IconData iconData;
  final String label;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), 
            )
          ]          
        ),
        
        margin: const EdgeInsets.all(8),
        child: Container(
          width: 150,
          height: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 3
          ),
          child: Column(
            children: [
              // count if count
              if(count != null)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(count.toString(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
                ),
              ),
              if(count == null)
              const SizedBox(height: 15,),
    
              // Icon
              Center(
                child: Icon(iconData, size: 40, color: Theme.of(context).colorScheme.secondary,)
              ),
              // label
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1),),
                ),
              ),
    
            ],
          ),
        ),
      ),
    );
  }
}