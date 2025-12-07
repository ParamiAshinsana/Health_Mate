import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:course_work_1a/features/health_entries/health_entries_dao.dart';
import 'package:course_work_1a/features/health_entries/health_entries_model.dart';

class SearchEntriesUI extends StatefulWidget {
  const SearchEntriesUI({super.key});

  @override
  State<SearchEntriesUI> createState() => _SearchEntriesUIState();
}

class _SearchEntriesUIState extends State<SearchEntriesUI> {
  final Color mainColor = const Color(0xFF03FCDF);
  final Color backgroundColor = const Color(0xFF0D1117);
  final Color cardColor = const Color(0xFF161B22);
  final Color borderColor = const Color(0xFF30363D);

  final HealthEntriesDao _healthEntriesDao = HealthEntriesDao();

  DateTime selectedDate = DateTime.now();
  bool isSearching = false;
  bool hasSearched = false;

  // Search results
  int searchSteps = 0;
  int searchCalories = 0;
  int searchWater = 0;
  List<HealthRecord> searchRecords = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: mainColor,
              onPrimary: Colors.black,
              surface: cardColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: backgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hasSearched = false; // Reset search when date changes
      });
    }
  }

  Future<void> _searchRecords() async {
    setState(() {
      isSearching = true;
    });

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      final records = await _healthEntriesDao.getHealthRecordsByDate(dateStr);

      // Print to console
      print('========================================');
      print('🔍 SEARCHING RECORDS');
      print('📅 Date: $dateStr');
      print('📝 Records found: ${records.length}');

      if (records.isNotEmpty) {
        int totalSteps = 0;
        int totalCalories = 0;
        int totalWater = 0;

        for (var record in records) {
          totalSteps += record.steps;
          totalCalories += record.calories;
          totalWater += record.water;
          print('   - Steps: ${record.steps}, Calories: ${record.calories}, Water: ${record.water}');
        }

        setState(() {
          searchSteps = totalSteps;
          searchCalories = totalCalories;
          searchWater = totalWater;
          searchRecords = records;
        });

        print('📊 Total - Steps: $totalSteps, Calories: $totalCalories, Water: $totalWater ml');
      } else {
        setState(() {
          searchSteps = 0;
          searchCalories = 0;
          searchWater = 0;
          searchRecords = [];
        });
        print('⚠️ No records found for this date');
      }
      print('========================================');
    } catch (e) {
      print('❌ Error searching: $e');
      _showErrorSnackBar('Error searching records');
    } finally {
      setState(() {
        isSearching = false;
        hasSearched = true;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Back Button
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Search Records",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Placeholder for symmetry
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Date Picker Card
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: mainColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Date",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('MMMM dd, yyyy').format(selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [mainColor, mainColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isSearching ? null : _searchRecords,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isSearching
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Search",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Results Section
                    if (hasSearched) ...[
                      // Results Title
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Results for ${DateFormat('MMM dd, yyyy').format(selectedDate)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (searchRecords.isEmpty)
                        // No Records Found
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 60,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No records found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "No health data for this date",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Steps Card
                        _buildResultCard(
                          icon: Icons.directions_walk,
                          title: "Steps",
                          value: NumberFormat('#,###').format(searchSteps),
                          subtitle: "steps walked",
                        ),

                        // Calories Card
                        _buildResultCard(
                          icon: Icons.local_fire_department,
                          title: "Calories",
                          value: NumberFormat('#,###').format(searchCalories),
                          subtitle: "kcal burned",
                        ),

                        // Water Intake Card
                        _buildResultCard(
                          icon: Icons.water_drop,
                          title: "Water Intake",
                          value: "${NumberFormat('#,###').format(searchWater)} ml",
                          subtitle: "water consumed",
                        ),
                      ],
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: mainColor.withOpacity(0.3), width: 1),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

