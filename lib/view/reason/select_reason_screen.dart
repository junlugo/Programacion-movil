// ignore_for_file: deprecated_member_use

import 'package:finpay/config/textstyle.dart';
import 'package:finpay/view/login/create_pin_screen.dart';
import 'package:finpay/view/reason/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SelectReasonScreen extends StatefulWidget {
  const SelectReasonScreen({Key? key}) : super(key: key);

  @override
  State<SelectReasonScreen> createState() => _SelectReasonScreenState();
}

class _SelectReasonScreenState extends State<SelectReasonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Container(
          color: AppTheme.isLightTheme == false
              ? const Color(0xff15141F)
              : Colors.white,
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: AppBar().preferredSize.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Text(
                    "Razón principal para utilizar FinPay",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Necesitamos conocer estas razones regulatorias. Y también tenemos curiosidad.!",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xffA2A0A8),
                        ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  customReasonContainer(context, "Gastar o ahorrar diariamente", () {
                    Get.to(
                      const CreateNewPinScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  customReasonContainer(context, "Gastar mientras viaja", () {
                    Get.to(
                      const CreateNewPinScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  customReasonContainer(context, "Enviar dinero", () {
                    Get.to(
                      const CreateNewPinScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  customReasonContainer(
                      context, "Obtenga exposición a activos financieros", () {
                    Get.to(
                      const CreateNewPinScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  })
                  // Expanded(

                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
