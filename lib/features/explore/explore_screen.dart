import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../more_screens/token_details_screen.dart';
import '../../core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import '../main/screens/main_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> categories = [
    'Favourite',
    'Top',
    'Trending',
    'New',
    'Gainers'
  ];
  String selectedCategory = 'Favourite';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildCategories(),
        _buildTableHeader(),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ColorConstants.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for any tokens',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? ColorConstants.primaryPurple
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color:
                      isSelected ? ColorConstants.primaryPurple : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniChart(bool isPositive) {
    final color = isPositive ? const Color(0xFF4CAF50) : Colors.red;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1.2),
                FlSpot(1, 1.5),
                FlSpot(2, 1.1),
                FlSpot(3, 1.3),
                FlSpot(4, 0.9),
                FlSpot(5, 1.4),
                FlSpot(6, 1.2),
              ],
              isCurved: true,
              curveSmoothness: 0.35, // Smoother curve
              color: color,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.02),
                  ],
                  stops: const [0.1, 0.9],
                ),
              ),
              shadow: Shadow(
                color: color.withOpacity(0.25),
                blurRadius: 8,
              ),
            ),
          ],
          lineTouchData: LineTouchData(enabled: false),
          clipData: FlClipData.all(),
          backgroundColor: Colors.transparent,
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 2,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      // Increased horizontal padding
      child: Row(
        children: [
          // Token Name column (left-aligned)
          Expanded(
            flex: 3, // Increased flex for more space
            child: Text(
              '\$token Name',
              style: TextStyle(
                color: Color(0x60FFFFFF),
                fontSize: 12,
              ),
            ),
          ),
          // Graph column (center-aligned)
          Expanded(
            flex: 3, // Adjusted flex ratio
            child: Text(
              'Graph (30 days)',
              style: TextStyle(
                color: Color(0x60FFFFFF),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Price column (right-aligned)
          Expanded(
            flex: 3, // Adjusted flex ratio
            child: Text(
              'Price & 24H change',
              style: TextStyle(
                color: Color(0x60FFFFFF),
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _buildTokenItem(
          'Sofia Santos',
          '\$sofias',
          'assets/default_user.png',
          3.91002,
          4011,
          41.2,
          true,
        ),
        _buildTokenItem(
          'Ethan Nguyen',
          '\$ethann',
          'assets/default_user.png',
          6.00912,
          3106,
          14.2,
          true,
        ),
        _buildTokenItem(
          'Lila Patel',
          '\$lilapa',
          'assets/default_user.png',
          8.50192,
          8101,
          -12.4,
          false,
        ),
        _buildTokenItem(
          'Omar Khan',
          '\$omarkh',
          'assets/default_user.png',
          3.00912,
          3000,
          21.4,
          true,
        ),
      ],
    );
  }

  Widget _buildTokenItem(String name, String handle, String avatar,
      double price, int dollarValue, double change, bool isPositive) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => TokenDetailsScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        // Increased horizontal padding
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: ColorConstants.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Name and handle section
            Expanded(
              flex: 5, // Increased flex for more space
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        handle,
                        style: const TextStyle(
                          color: Color(0x60FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Graph section
            Expanded(
              flex: 3, // Adjusted flex ratio
              child: Center(
                // Center the chart
                child: _buildMiniChart(isPositive),
              ),
            ),
            // Price and change section
            Expanded(
              flex: 4, // Adjusted flex ratio
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${price.toStringAsFixed(5)} (\$${dollarValue})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4), // Added spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            isPositive ? const Color(0xFF4CAF50) : Colors.red,
                        size: 20,
                      ),
                      Text(
                        '${change.abs()}%',
                        style: TextStyle(
                          color:
                              isPositive ? const Color(0xFF40B876) : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
