import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final bool ? isLoading;
  final Widget ? child;

  const LoadingWidget({super.key, this.isLoading, this.child});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
        isLoading!? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black87,
          child:  const Center(
            child: SpinKitDoubleBounce(
              color: Colors.blue,
            ),
          ),
        ):const SizedBox(),
      ],
    );
  }
}
