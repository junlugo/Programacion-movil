// ignore_for_file: sized_box_for_whitespace, file_names, prefer_const_constructors, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/view/proof/upload_photo_screen.dart';
import 'package:finpay/view/proof/widget/customMethodContainer.dart';
import 'package:finpay/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RedsidencyProofScreen extends StatefulWidget {
  const RedsidencyProofScreen({Key? key}) : super(key: key);

  @override
  State<RedsidencyProofScreen> createState() => _RedsidencyProofScreenState();
}

class _RedsidencyProofScreenState extends State<RedsidencyProofScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: AppTheme.isLightTheme == false
                ? const Color(0xff15141F)
                : Colors.white,
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
                    height: 28,
                  ),
                  Text(
                    "Comprobante de residencia",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Demuestre que vive en Paraguay",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xffA2A0A8),
                        ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Nacionalidad",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: const Color(0xffA2A0A8),
                                  ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 72,
                            decoration: BoxDecoration(
                                color: AppTheme.isLightTheme == false
                                    ? const Color(0xff211F32)
                                    : const Color(0xffF9F9FA),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: SvgPicture.asset(
                                          DefaultImages.flag,
                                          fit: BoxFit.cover,
                                          // color:  HexColor(AppTheme.secondaryColorString!)
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Paraguay",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: AppTheme
                                                              .isLightTheme ==
                                                          false
                                                      ? Colors.white
                                                      : const Color(0xff15141F),
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Text("Cambiar",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: HexColor(AppTheme
                                                    .primaryColorString!))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Método de verificación",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: const Color(0xffA2A0A8),
                                  ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        customMethodContainer(
                            context,
                            "Pasaporte",
                            "Expedido en Paraguay",
                            DefaultImages.passport,
                            () {}),
                        const SizedBox(
                          height: 16,
                        ),
                        customMethodContainer(
                            context,
                            "Carnet de identidad",
                            "Expedido en Paraguay",
                            DefaultImages.identityCard,
                            () {}),
                        const SizedBox(
                          height: 16,
                        ),
                        customMethodContainer(
                            context,
                            "Mi documento digital de información",
                            "Expedido en Paraguay",
                            DefaultImages.digitalDoc,
                            () {}),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        const UploadPhotoScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: customButton(
                        HexColor(AppTheme.primaryColorString!),
                        "Continuar",
                        HexColor(AppTheme.secondaryColorString!),
                        context),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
