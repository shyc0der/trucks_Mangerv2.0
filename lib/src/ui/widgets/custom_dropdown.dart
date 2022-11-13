import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({required this.label, this.value, required this.items, this.onChanged, this.isNullable = false, Key? key }) : super(key: key);
  final String label;
  final String? value;
  final Map<String, dynamic> items;
  final void Function(String? val)? onChanged;
  final bool isNullable;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    setState(() {
      _value = widget.value;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(width: 80, child: Text(widget.label)),),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: .8, color: Colors.grey),
            ),
            child: Row(
              children: [
                if(_value != null && widget.isNullable) IconButton(
                  onPressed: (){
                    setState(() {
                      _value = null;
                    });
                    widget.onChanged?.call(_value);
                  }, 
                  icon: const Icon(Icons.clear,)
                ),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    value: _value,
                    onChanged: widget.onChanged,
                    decoration: const InputDecoration(border:  UnderlineInputBorder(borderSide: BorderSide.none)),
                              
                    items:[
                      for(var key in widget.items.keys)
                      DropdownMenuItem(
                        value: key,
                        child: Text(widget.items[key].toString()))
                    ]
                  ),
                ),
              ],
            ),
          )
        
        ),

    ],);
  }
}