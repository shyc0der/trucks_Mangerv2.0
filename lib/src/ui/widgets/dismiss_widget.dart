import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<bool?> dismissWidget (String label){
  return Get.dialog<bool?>(
                        
                      Dialog(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(text: TextSpan(
                                  text:"Are you sure you want to ",
                                  style: const TextStyle(fontSize: 18,color: Colors.black87),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Delete ',style:TextStyle(
                                      fontWeight:FontWeight.bold,color: Colors.red,
                                      fontSize: 18
                                    ,
                                    ),
                                    
                                    ),
                                    TextSpan(text: label ,style:
                                    
                                    const TextStyle(
                                      color: Colors.black87,
                                        fontSize: 18))
                                    ,
                                  ]
                                   ),),
                                //rText("Are you sure you want to DELETE ${expense.name}?"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // yes
                                      TextButton(onPressed: ()=> Get.back(result: true), child: 
                                     const Text('Yes delete!', 
                                      style:  TextStyle(color: Colors.redAccent,fontSize: 18),)),

                                      // no
                                      ElevatedButton(
                                        onPressed: ()=> Get.back(result: false), child: 
                                        const Text('Cancel',
                                        style: TextStyle(fontSize: 18)
                                        ),
                                        // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
  );

}