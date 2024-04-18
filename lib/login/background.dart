import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Container(
  //     width: double.infinity,
  //     height: size.height,
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: <Widget>[
  //         Positioned(
  //           top: 0,
  //           right: 0,
  //           child: Image.asset(
  //               "assets/login/top1.png",
  //               width: size.width
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           right: 0,
  //           child: Image.asset(
  //               "assets/login/top2.png",
  //               width: size.width
  //           ),
  //         ),
  //         Positioned(
  //           top: 50,
  //           right: 30,
  //           child: Image.asset(
  //               "assets/login/main.png",
  //               width: size.width * 0.35
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 0,
  //           right: 0,
  //           child: Image.asset(
  //               "assets/login/bottom1.png",
  //               width: size.width
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 0,
  //           right: 0,
  //           child: Image.asset(
  //               "assets/login/bottom2.png",
  //               width: size.width
  //           ),
  //         ),
  //         child
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event here, start the water animation
        print('Background tapped');
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Your background image or color
          Container(
            color: Colors.blue, // Change to your background color or image
          ),
          // Custom widget for water effect
          AnimatedWater(),
        ],
      ),
    );
  }
}
class AnimatedWater extends StatefulWidget {
  @override
  _AnimatedWaterState createState() => _AnimatedWaterState();
}

class _AnimatedWaterState extends State<AnimatedWater> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      // Adjust the properties of the container to create the water effect
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue.withOpacity(0.4),
            Colors.lightBlue.withOpacity(0.8),
          ],
        ),
      ),
    );
  }
}