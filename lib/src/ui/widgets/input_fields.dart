// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget InputField(String label, TextEditingController controller, bool error, {
  Function(String val)? onChanged, bool isNumbers = false, bool invalid = false, bool isHidden = false, int maxLines = 1,
  TextInputType? keyboardType
}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          // label
          SizedBox(width: 80, child: Text('$label:')),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: .8, color: error ? Colors.redAccent : Colors.grey)
              ),
              child: TextField(
                keyboardType: keyboardType,
                controller: controller,
                onChanged: onChanged,
                obscureText: isHidden,
                maxLines: maxLines,
                inputFormatters: [
                  if(isNumbers) FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))
                ],
                decoration: InputDecoration(
                  errorText: error ? "\t\t*required!" : invalid ? "\t\t*$label invalid!" : null,
                  border: const UnderlineInputBorder(borderSide: BorderSide.none)),
              ),
            )
          ),
        ],
      ),
    );
  }