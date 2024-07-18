import 'package:flutter/material.dart';
//Creating constructor to get diffrent values
class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label ;
  final String value ;
  const AdditionalInformation({
    super.key, required this.icon, required this.label, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon,size: 45,),
        Text(label,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        Text(value,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
      ],
    );
  }
}