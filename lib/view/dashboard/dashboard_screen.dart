import 'package:flutter/material.dart';
import 'package:okra_distributer/components/text_component.dart';
import 'package:okra_distributer/consts/const.dart';
import 'package:okra_distributer/view/dashboard/bar_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const AppText(
            title: "Dashbaord Screen",
            color: Colors.white,
            font_size: 22,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        backgroundColor: appBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  AppText(
                      title: "Sales and Purchase Overview",
                      color: Colors.black,
                      font_size: 19,
                      fontWeight: FontWeight.w600)
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              BarChartSample2(),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage("assets/images/sale.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Items",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage(
                                    "assets/images/daily-expense.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Categories",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  AppText(
                      title: "Quick Overview",
                      color: Colors.black,
                      font_size: 19,
                      fontWeight: FontWeight.w600)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage("assets/images/income.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Income",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80,0000",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage(
                                    "assets/images/daily-expense.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Expenses",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage(
                                    "assets/images/daily-expense.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Due",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80,0000",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage("assets/images/sale.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Stock value",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "250505",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  AppText(
                      title: "Loss/ Profit",
                      color: Colors.black,
                      font_size: 19,
                      fontWeight: FontWeight.w600)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage("assets/images/sale.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Loss",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80,0000",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                  color: appBlue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Image(
                                image: AssetImage("assets/images/sale.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    title: "Total Profit",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w500),
                                AppText(
                                    title: "80",
                                    color: Colors.black,
                                    font_size: 13,
                                    fontWeight: FontWeight.w600)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
