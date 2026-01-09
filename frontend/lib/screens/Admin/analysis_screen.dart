import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../features/auth/data/analysis/analysis_model.dart';
import '../../features/auth/data/analysis/analysis_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  AnalysisModel? _analysis;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  Future<void> _loadAnalysis() async {
    try {
      final result = await AnalysisService().getAnalysis();
      if (!mounted) return;
      setState(() {
        _analysis = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Analysis"),
        backgroundColor: kTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTitle("Donation Summary"),
            const SizedBox(height: 20),
            _buildDonutChart(),
            const SizedBox(height: 30),
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 65,
          sectionsSpace: 3,
          startDegreeOffset: -90,
          sections: [
            PieChartSectionData(
              color: const Color(0xff3e4a89),
              value: _analysis!.users.toDouble(),
              title: "",
              radius: 40,
            ),
            PieChartSectionData(
              color: kTeal,
              value: _analysis!.donations.toDouble(),
              title: "",
              radius: 40,
            ),
            PieChartSectionData(
              color: const Color(0xff65d6ce),
              value: _analysis!.requests.toDouble(),
              title: "",
              radius: 40,
            ),
            PieChartSectionData(
              color: const Color(0xffa2b1ff),
              value: _analysis!.userRequests.toDouble(),
              title: "",
              radius: 40,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatsGrid() {
    final total = _analysis!.users +
        _analysis!.donations +
        _analysis!.requests +
        _analysis!.userRequests;

    String percent(int value) =>
        total == 0 ? "0%" : "${((value / total) * 100).toStringAsFixed(1)}%";

    final stats = [
      {
        "title": "Users",
        "percent": percent(_analysis!.users),
        "color": const Color(0xff3e4a89),
      },
      {
        "title": "Donations",
        "percent": percent(_analysis!.donations),
        "color": kTeal,
      },
      {
        "title": "Requests",
        "percent": percent(_analysis!.requests),
        "color": const Color(0xff65d6ce),
      },
      {
        "title": "User Requests",
        "percent": percent(_analysis!.userRequests),
        "color": const Color(0xffa2b1ff),
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: stats.map((s) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: (s["color"] as Color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    s["title"] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    s["percent"] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
