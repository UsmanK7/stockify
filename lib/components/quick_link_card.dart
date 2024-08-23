import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';

class QuickLinkCard extends StatelessWidget {
  String text;
  String imgpath;
  Function() ontap;
  QuickLinkCard(
      {super.key,
      required this.imgpath,
      required this.text,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: appBlue, borderRadius: BorderRadius.circular(50)),
                child: Image(
                  image: AssetImage(imgpath),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              AppText(
                  title: text,
                  color: Colors.black,
                  font_size: 13,
                  fontWeight: FontWeight.w600)
            ],
          ),
        ),
      ),
    );
  }
}
