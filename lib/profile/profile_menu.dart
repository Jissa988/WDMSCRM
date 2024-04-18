import 'package:customer_portal/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ProfileMenu extends StatelessWidget {
   ProfileMenu({
    Key? key,
    required this.textEditingController,
    required this.icon,
     required this.isobstruct,
     required this.placeholder,
     this.onChanged, this.press,
  }) : super(key: key);

  final TextEditingController textEditingController;
  String icon,placeholder;
  bool isobstruct;
  final VoidCallback? press;
   final ValueChanged<String>? onChanged;


   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.background, padding: const EdgeInsets.all(12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(
              icon,
              // color: kPrimaryColor,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: textEditingController, // Use a TextEditingController to control the text input
               obscureText: isobstruct,
                cursorColor: AppColors.theme_color,
                decoration: InputDecoration(
                  hintText: placeholder,
                  // Placeholder text
                  // border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .theme_color), // Set the color of the focused border
                  ),
                ),

                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                 onChanged: onChanged, // Call the onChanged callback when the text changes
              ),
            ),

            // const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}