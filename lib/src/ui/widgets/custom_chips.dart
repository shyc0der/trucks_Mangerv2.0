import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomChips extends StatefulWidget {
  const CustomChips({required this.items, this.initial, this.onChanged, this.label, Key? key }) : super(key: key);
  final String? label;
  final List<String> items;
  final List<String>? initial;
  final void Function(List<String> selected)? onChanged;

  @override
  State<CustomChips> createState() => _CustomChipsState();
}

class _CustomChipsState extends State<CustomChips> {
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    if(widget.initial != null){
      _selected = widget.initial!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if(widget.label != null) Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(widget.label!, style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
        Wrap(
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  _selected.clear();
                });
              },
              child: Card(
                color: _selected.isEmpty || _selected.length == widget.items.length  ? Get.theme.primaryColor.withOpacity(.2): null,
                child: const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('All'),
                ),
              ),
            ),
            for(var item in widget.items)
              InkWell(
                onTap: (){
                  if(_selected.contains(item)){
                    _selected.remove(item);
                  }else{
                    _selected.add(item);
                  }
                  setState(() {});
                },
                child: Card(
                  color: _selected.contains(item) ? Get.theme.primaryColor.withOpacity(.2): null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}