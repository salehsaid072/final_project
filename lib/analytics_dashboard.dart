import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  DateTimeRange? dateRange;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Map<String, dynamic>? analyticsData;
  
  @override
  void initState() {
    super.initState();
    _loadDateRange();
    _fetchAnalyticsData();
  }

  Future<void> _loadDateRange() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final startDate = prefs.getString('analytics_start_date');
      final endDate = prefs.getString('analytics_end_date');

      if (startDate != null && endDate != null) {
        setState(() {
          dateRange = DateTimeRange(
            start: DateTime.parse(startDate),
            end: DateTime.parse(endDate),
          );
        });
      }
    } catch (e) {
      print('Error loading date range: $e');
    }
  }

  Future<void> _saveDateRange(DateTimeRange range) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('analytics_start_date', range.start.toString());
      await prefs.setString('analytics_end_date', range.end.toString());
    } catch (e) {
      print('Error saving date range: $e');
    }
  }

  Future<void> _fetchAnalyticsData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // In a real app, you would make an API call here
      // For now, using mock data
      final mockData = {
        'totalSales': 1500000,
        'totalOrders': 250,
        'activeUsers': 1200,
        'monthlySales': [
          {'month': 'Jan', 'sales': 150000},
          {'month': 'Feb', 'sales': 180000},
          {'month': 'Mar', 'sales': 200000},
          {'month': 'Apr', 'sales': 220000},
          {'month': 'May', 'sales': 250000},
          {'month': 'Jun', 'sales': 280000},
        ],
        'categoryDistribution': {
          'Fruits': 30,
          'Vegetables': 45,
          'Grains': 20,
          'Dairy': 15,
          'Meat': 10,
        },
        'userTypes': {
          'Farmers': 700,
          'Buyers': 500,
        },
      };

      setState(() {
        analyticsData = mockData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load analytics data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAnalyticsData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchAnalyticsData,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dateRange != null
                                        ? 'Date Range: ${DateFormat('MMM d, yyyy').format(dateRange!.start)} - ${DateFormat('MMM d, yyyy').format(dateRange!.end)}'
                                        : 'Select Date Range',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    final DateTimeRange? newRange = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime.now(),
                                      initialDateRange: dateRange,
                                    );
                                    if (newRange != null) {
                                      setState(() {
                                        dateRange = newRange;
                                      });
                                      _saveDateRange(newRange);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                title: 'Total Sales',
                                value: analyticsData != null ? 'TZS ${analyticsData!['totalSales']}' : 'N/A',
                                icon: Icons.attach_money,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                title: 'Total Orders',
                                value: analyticsData != null ? '${analyticsData!['totalOrders']}' : 'N/A',
                                icon: Icons.shopping_cart,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                title: 'Active Users',
                                value: analyticsData != null ? '${analyticsData!['activeUsers']}' : 'N/A',
                                icon: Icons.people,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Monthly Sales',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: _buildMonthlySalesChart(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Category Distribution',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: _buildCategoryDistributionChart(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'User Type Distribution',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: _buildUserTypeChart(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlySalesChart() {
    if (analyticsData == null || !analyticsData!.containsKey('monthlySales')) return const SizedBox();
    final monthlySales = analyticsData!['monthlySales'] as List<dynamic>?;
    if (monthlySales == null || monthlySales.isEmpty) return const SizedBox();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, titleMeta) {
                if (value.toInt() >= 0 && value.toInt() < monthlySales.length) {
                  return Text(
                    monthlySales[value.toInt()]['month'] as String? ?? '',
                    style: const TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              monthlySales.length,
              (index) => FlSpot(
                index.toDouble(),
                (monthlySales[index]['sales'] as num? ?? 0) / 100000,
              ),
            ),
            isCurved: true,
            color: Colors.teal,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color.fromARGB(255, 13, 236, 214).withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistributionChart() {
    if (analyticsData == null || !analyticsData!.containsKey('categoryDistribution')) return const SizedBox();
    final categoryDistribution = analyticsData!['categoryDistribution'] as Map<String, dynamic>?;
    if (categoryDistribution == null || categoryDistribution.isEmpty) return const SizedBox();

    return PieChart(
      PieChartData(
        sections: List.generate(
          categoryDistribution.length,
          (index) {
            final category = categoryDistribution.keys.elementAt(index);
            final value = categoryDistribution[category] as num? ?? 0;
            return PieChartSectionData(
              color: Colors.teal[100 * (index + 1)] ?? Colors.teal,
              value: value.toDouble(),
              title: category,
              radius: 50,
              titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              showTitle: true,
            );
          },
        ),
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildUserTypeChart() {
    if (analyticsData == null || !analyticsData!.containsKey('userTypes')) return const SizedBox();
    final userTypes = analyticsData!['userTypes'] as Map<String, dynamic>?;
    if (userTypes == null || userTypes.isEmpty) return const SizedBox();

    return PieChart(
      PieChartData(
        sections: List.generate(
          userTypes.length,
          (index) {
            final type = userTypes.keys.elementAt(index);
            final value = userTypes[type] as num? ?? 0;
            return PieChartSectionData(
              color: Colors.teal[100 * (index + 1)] ?? Colors.teal,
              value: value.toDouble(),
              title: type,
              radius: 50,
              titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              showTitle: true,
            );
          },
        ),
        centerSpaceRadius: 40,
      ),
    );
  }
}
