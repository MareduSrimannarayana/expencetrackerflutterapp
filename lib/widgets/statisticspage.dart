import 'package:expenceapp/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stpro = FutureProvider((ref) {
  return DataBaseService.instance.getCategorySums();
});

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(stpro);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            _buildLegend(),
            const Divider(),
            st.when(
                data: (data) {
                  final double totalp;

                  totalp = (data["Entertainment"] ?? 0) +
                      (data["Food"] ?? 0) +
                      (data["Travel"] ?? 0);
                  return SizedBox(
                    height: 500,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text("Expenses"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            swapAnimationDuration:
                                const Duration(milliseconds: 0),
                            swapAnimationCurve: Curves.easeInOutQuint,
                            PieChartData(
                                // titleSunbeamLayout: true,
                                // centerSpaceRadius: 100,
                                sections: [
                                  PieChartSectionData(
                                      showTitle: true,
                                      title:
                                          "${(((data["Entertainment"] ?? 0) / totalp) * 100).toStringAsFixed(2)} %",
                                      value: ((data["Entertainment"] ?? 0) /
                                              totalp) *
                                          100,
                                      color: Colors.red),
                                  PieChartSectionData(
                                      showTitle: true,
                                      title:
                                          "${(((data["Food"] ?? 0) / totalp) * 100).toStringAsFixed(2)} %",
                                      value:
                                          ((data["Food"] ?? 0) / totalp) * 100,
                                      color: Colors.lightBlue),
                                  PieChartSectionData(
                                      showTitle: true,
                                      title:
                                          "${(((data["Travel"] ?? 0) / totalp) * 100).toStringAsFixed(2)} %",
                                      value: ((data["Travel"] ?? 0) / totalp) *
                                          100,
                                      color: Colors.green),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (StackTrace, error) => const Text("data"),
                loading: () => const CircularProgressIndicator()),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(color: Colors.red, text: "Entertainment"),
          _LegendItem(color: Colors.blue, text: "Food"),
          _LegendItem(color: Colors.green, text: "Travel"),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}