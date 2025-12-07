import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:course_work_1a/features/health_entries/ui/add_health_entries.dart';
import 'package:course_work_1a/features/health_entries/ui/view_health_entries.dart';
import 'package:course_work_1a/features/health_entries/health_entries_dao.dart';
import 'package:course_work_1a/features/health_entries/health_entries_model.dart';
import 'package:course_work_1a/features/search_records/serach_entries_ui.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Color mainColor = const Color(0xFF03FCDF);
  final Color backgroundColor = const Color(0xFF0D1117);
  final Color cardColor = const Color(0xFF161B22);
  final Color borderColor = const Color(0xFF30363D);

  final HealthEntriesDao _healthEntriesDao = HealthEntriesDao();
  
  // Today's data
  int todaySteps = 0;
  int todayCalories = 0;
  int todayWater = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get today's date in the same format as stored in database
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Fetch today's records
      final records = await _healthEntriesDao.getHealthRecordsByDate(today);
      
      // Print to console
      print('========================================');
      print('📊 LOADING TODAY\'S DATA');
      print('📅 Date: $today');
      print('📝 Records found: ${records.length}');
      
      if (records.isNotEmpty) {
        // Sum up all entries for today (in case there are multiple)
        int totalSteps = 0;
        int totalCalories = 0;
        int totalWater = 0;
        
        for (var record in records) {
          totalSteps += record.steps;
          totalCalories += record.calories;
          totalWater += record.water;
          print('   - ID: ${record.id}, Steps: ${record.steps}, Calories: ${record.calories}, Water: ${record.water}');
        }
        
        setState(() {
          todaySteps = totalSteps;
          todayCalories = totalCalories;
          todayWater = totalWater;
        });
        
        print('📊 Total - Steps: $totalSteps, Calories: $totalCalories, Water: $totalWater ml');
      } else {
        setState(() {
          todaySteps = 0;
          todayCalories = 0;
          todayWater = 0;
        });
        print('⚠️ No records found for today');
      }
      print('========================================');
    } catch (e) {
      print('❌ Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header Section with gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    mainColor,
                    mainColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Top Row: Back icon + Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Icon
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Profile Image
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello Parami !",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Let's check your health today",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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
                        const Text(
                          "Today's Results",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // Refresh button
                        GestureDetector(
                          onTap: _loadTodayData,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: mainColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Steps Card
                    _buildHealthCard(
                      icon: Icons.directions_walk,
                      title: "Steps",
                      value: NumberFormat('#,###').format(todaySteps),
                      subtitle: "steps walked today",
                    ),

                    // Calories Card
                    _buildHealthCard(
                      icon: Icons.local_fire_department,
                      title: "Calories",
                      value: NumberFormat('#,###').format(todayCalories),
                      subtitle: "kcal burned today",
                    ),

                    // Water Intake Card
                    _buildHealthCard(
                      icon: Icons.water_drop,
                      title: "Water Intake",
                      value: "${NumberFormat('#,###').format(todayWater)} ml",
                      subtitle: "water consumed today",
                    ),

                    const Spacer(),

                    // Footer Buttons
                    Row(
                      children: [
                        // Search Records Button
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [mainColor, mainColor.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchEntriesUI(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, color: Colors.black, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    "Search",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // View Records Button
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: mainColor, width: 2),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ViewHealthEntries(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.visibility, color: mainColor, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    "View",
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainColor, mainColor.withOpacity(0.8)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            // Navigate to add entry and wait for result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHealthEntries(),
              ),
            );
            
            // If entry was saved successfully, refresh the data
            if (result == true) {
              _loadTodayData();
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                isLoading
                    ? SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          color: mainColor,
                          backgroundColor: borderColor,
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                if (!isLoading)
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
