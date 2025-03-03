import 'package:flutter/material.dart';

/* Since we have used all the row for multiple time we are creating 
            a sperate class for it on spearate dart file*/

class AddtionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const AddtionalInfoItem({
    super.key, required this.icon, required this.title, required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Row 1 -> symbol. 
      Icon(icon, size: 35,),
      const SizedBox(height: 8,),
      // Row 2 -> name.
      Text(title,),
      const SizedBox(height: 8,),
      // Row 3 -> tempreture.
      Text(value,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold                  
      ),),
    ],);
  }
} 