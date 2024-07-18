import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time ;
  final String value ;
  final IconData icon;
  const HourlyForecast({super.key, required this.time, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return
       SizedBox(
        height:150 ,
        width: 100,
        child: Card(
          elevation: 10,
          shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(time,
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                   maxLines : 1,
                   overflow: TextOverflow.ellipsis,

                ),
                Icon(icon,size: 40,),
                Text(value, style : TextStyle(fontSize: 20,)),
              ]

          ),
        ),

      );
  }
}