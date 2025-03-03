/* Since we have used all the row for multiple time we are creating 
            a sperate class for it on spearate dart file*/

import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  final int iconsize;

  const ForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.iconsize,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // column 1. Time
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines:
                    1, // our time which was 2 line text so we did this property to restict the lines.
                overflow: TextOverflow
                    .ellipsis, // sice we are making it 1 line so if it is more than 1 line it will show ... at the end.
              ),

              // column 2. Cloud
              const SizedBox(
                height: 8,
              ),
              Icon(icon, size: 32),

              // column 3. Weather
              const SizedBox(
                height: 8,
              ),
              Text(temp),
            ],
          ),
        ),
      ),
    );
  }
}
