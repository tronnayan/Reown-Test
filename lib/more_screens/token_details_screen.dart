import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/home/dashboard_screen.dart';

import '../core/routes/app_routes.dart';

class TokenDetailsScreen extends StatefulWidget {
  @override
  _TokenDetailsScreenState createState() => _TokenDetailsScreenState();
}

class _TokenDetailsScreenState extends State<TokenDetailsScreen> {
  String selectedPeriod = '24h';

  // Sample data maps for different time periods
  final Map<String, List<FlSpot>> timeData = {
    '24h': [
      FlSpot(0, 3),
      FlSpot(4, 2),
      FlSpot(8, 5),
      FlSpot(12, 3.1),
      FlSpot(16, 4),
      FlSpot(20, 3),
    ],
    '7d': [
      FlSpot(0, 4),
      FlSpot(1, 3.5),
      FlSpot(2, 4.5),
      FlSpot(3, 4.1),
      FlSpot(5, 3.8),
      FlSpot(6, 4.2),
    ],
    '1m': [
      FlSpot(0, 3.5),
      FlSpot(7, 4),
      FlSpot(14, 3.8),
      FlSpot(21, 4.2),
      FlSpot(28, 3.9),
      FlSpot(30, 4.1),
    ],
    '1y': [
      FlSpot(0, 2.8),
      FlSpot(60, 3.5),
      FlSpot(120, 4.2),
      FlSpot(180, 3.9),
      FlSpot(240, 4.4),
      FlSpot(300, 4.1),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Token Header
              const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/default_user.png'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitcoin (BTC)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$29,342.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Time Period Selector
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    // Added container to control width
                    width: MediaQuery.of(context).size.width -
                        32, // Accounting for parent padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+2.34% (24h)',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _buildTimePeriodButton('24h'),
                            _buildTimePeriodButton('7d'),
                            _buildTimePeriodButton('1m'),
                            _buildTimePeriodButton('1y'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chart
              Container(
                height: 250,
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: 18,
                ),
                decoration: BoxDecoration(
                  color: ColorConstants.secondaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.1),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                String text = '';
                                switch (selectedPeriod) {
                                  case '24h':
                                    text = '${value.toInt()}h';
                                    break;
                                  case '7d':
                                    text = 'D${value.toInt() + 1}';
                                    break;
                                  case '1m':
                                    text = '${value.toInt()}d';
                                    break;
                                  case '1y':
                                    text = 'M${(value / 30).toInt() + 1}';
                                    break;
                                }
                                return Text(
                                  text,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                  ),
                                );
                              },
                              interval: selectedPeriod == '1y'
                                  ? 60
                                  : selectedPeriod == '1m'
                                      ? 7
                                      : 4,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toInt()}K',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                  ),
                                );
                              },
                              interval: 1,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: timeData[selectedPeriod]!,
                            isCurved: true,
                            color: ColorConstants.primaryPurple,
                            barWidth: 2,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: ColorConstants.primaryPurple,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color:
                                  ColorConstants.primaryPurple.withOpacity(0.2),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.grey[800]!,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                return LineTooltipItem(
                                  '\$${touchedSpot.y.toStringAsFixed(2)}K',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: ColorConstants.primaryPurple),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Sell',
                        style: TextStyle(color: ColorConstants.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Buy'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Token Info Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildInfoCard('All Time High', '\$69,044.77'),
                  _buildInfoCard('All Time Low', '\$67.81'),
                  _buildInfoCard('Issue Date', 'Jan 3, 2009'),
                  _buildInfoCard('Max Supply', '21,000,000'),
                  _buildInfoCard('Created By', 'Satoshi Nakamoto',
                      isProfile: true),
                  _buildInfoCard('Your Balance', '0.0234 BTC'),
                ],
              ),
              // Action Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePeriodButton(String period) {
    bool isSelected = selectedPeriod == period;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color:
                isSelected ? ColorConstants.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            period,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorConstants.greyText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {bool isProfile = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => isProfile
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()))
                : '',
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
