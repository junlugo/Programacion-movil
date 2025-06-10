// ignore_for_file: unnecessary_new, prefer_const_constructors, unused_field, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/controller/tab_controller.dart';
import 'package:finpay/view/card/card_view.dart';
import 'package:finpay/view/home/home_view.dart';
import 'package:finpay/view/profile/profile_view.dart';
import 'package:finpay/view/statistics/statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final tabController = Get.put(TabScreenController());
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    tabController.customInit();
    homeController.customInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor(AppTheme.primaryColorString!),
        onPressed: () {},
        child: SvgPicture.asset(DefaultImages.scan),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            elevation: 20,
            currentIndex: tabController.pageIndex.value,
            onTap: (index) {
              tabController.pageIndex.value = index;
            },
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: const Color.fromARGB(255, 35, 247, 52),
            selectedItemColor: const Color.fromARGB(255, 35, 247, 52),
            items: [
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    DefaultImages.homr,
                    color: const Color.fromARGB(255, 35, 247, 52),
                  ),
                ),
                label: "Inicio",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    DefaultImages.chart,
                    color: const Color.fromARGB(255, 35, 247, 52),
                  ),
                ),
                label: "Reservas",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    DefaultImages.card,
                    color: const Color.fromARGB(255, 35, 247, 52),
                  ),
                ),
                label: "Partidos",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    DefaultImages.user,
                    color: const Color.fromARGB(255, 35, 247, 52),
                  ),
                ),
                label: "Perfil",
              ),
            ],
          )),
      body: GetX<TabScreenController>(
        builder: (controller) => controller.pageIndex.value == 0
            ? HomeView()
            : controller.pageIndex.value == 1
                ? const StatisticsView()
                : controller.pageIndex.value == 2
                    ? const CardView()
                    : const ProfileView(),
      ),
    );
  }
}
