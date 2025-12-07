import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:course_work_1a/features/health_entries/health_entries_dao.dart';
import 'package:course_work_1a/features/health_entries/health_entries_model.dart';

class AddHealthEntries extends StatefulWidget {
  const AddHealthEntries({super.key});

  @override
  State<AddHealthEntries> createState() => _AddHealthEntriesState();
}

class _AddHealthEntriesState extends State<AddHealthEntries> {
  final Color mainColor = const Color(0xFF03FCDF);
  final Color backgroundColor = const Color(0xFF0D1117);
  final Color cardColor = const Color(0xFF161B22);
  final Color inputBorderColor = const Color(0xFF30363D);

  DateTime selectedDate = DateTime.now();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController waterController = TextEditingController();

  
  final HealthEntriesDao _healthEntriesDao = HealthEntriesDao();
  bool _isSaving = false;

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
      });
    }
  }

  @override
  void dispose() {
    stepsController.dispose();
    caloriesController.dispose();
    waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: inputBorderColor,
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
                        "Add Health Entry",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

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
                            color: inputBorderColor,
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
                                  "Date",
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

                    const SizedBox(height: 30),

                    _buildInputField(
                      label: "Steps Walked",
                      controller: stepsController,
                      hintText: "8500",
                      icon: Icons.directions_walk_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    _buildInputField(
                      label: "Calories Burned",
                      controller: caloriesController,
                      hintText: "450",
                      icon: Icons.local_fire_department_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    _buildInputField(
                      label: "Water Intake (ml)",
                      controller: waterController,
                      hintText: "2000",
                      icon: Icons.water_drop_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 40),

                    Container(
                      width: double.infinity,
                      height: 56,
                      margin: const EdgeInsets.only(bottom: 30),
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
                        onPressed: _isSaving ? null : _saveEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Save Entry",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: inputBorderColor,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  icon,
                  color: mainColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveEntry() async {
    if (stepsController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        waterController.text.isEmpty) {
      _showErrorSnackBar('Please fill all fields');
      return;
    }

    final int? steps = int.tryParse(stepsController.text.replaceAll(',', ''));
    final int? calories = int.tryParse(caloriesController.text.replaceAll(',', ''));
    final int? water = int.tryParse(waterController.text.replaceAll(',', ''));

    if (steps == null || calories == null || water == null) {
      _showErrorSnackBar('Please enter valid numbers');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final healthRecord = HealthRecord(
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        steps: steps,
        calories: calories,
        water: water,
      );

      print('========================================');
      print('💾 SAVING HEALTH ENTRY TO DATABASE');
      print('========================================');
      print('📅 Date: ${healthRecord.date}');
      print('🚶 Steps: ${healthRecord.steps}');
      print('🔥 Calories: ${healthRecord.calories}');
      print('💧 Water: ${healthRecord.water} ml');
      print('========================================');

      final insertedId = await _healthEntriesDao.insertHealthRecord(healthRecord);
      
      print('✅ Record saved successfully with ID: $insertedId');
      print('========================================');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Health entry saved successfully!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: mainColor,
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

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error saving entry: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
}
