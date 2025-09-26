import 'package:flutter/material.dart';
import 'package:immunelink/screens/BoldText.dart';

class tile1 extends StatelessWidget {
  tile1({
    super.key,
    required this.imagePath,
    required this.price,
    required this.name});

  String imagePath;
  String price;
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 5),
            color: Colors.grey,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 230,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 175,
              width: double.infinity, // <-- FIXED
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              children: [
                BoldText(text: name, size: 17),
                Spacer(),
                BoldText(text: price, size: 17),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
