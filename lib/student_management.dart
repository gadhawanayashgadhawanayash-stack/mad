import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const CourseManagementApp());
}

// --- Data Model ---
class Course {
  final String name;
  final String faculty;
  final String duration;
  final String fees;
  final String description;

  Course({
    required this.name,
    required this.faculty,
    required this.duration,
    required this.fees,
    required this.description,
  });
}

// --- Main App Widget ---
class CourseManagementApp extends StatelessWidget {
  const CourseManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- 2. & 3. Splash Screen ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3. Display the logo for 10 seconds, then navigate
    Timer(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Course Management App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 40),

            // Atmiya University Logo using Internet Link
            Image.network(
              'https://atmiyauni.ac.in/wp-content/uploads/2019/07/Atmiya-University-logo.png', // Direct Image Link
              height: 200,
              width: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, size: 100, color: Color(0xFF1E3A8A));
              },
            ),

            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. & 5. Main Screen with Bottom Navigation Bar ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Shared state: List of courses
  final List<Course> _courses = [];

  void _addCourse(Course course) {
    setState(() {
      _courses.add(course);
      _selectedIndex = 2; // Automatically navigate to Course List after saving
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 6. Screens for Home, Form, and List
    final List<Widget> screens = [
      const HomeScreen(),
      CourseFormScreen(onSave: _addCourse),
      CourseListScreen(courses: _courses),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Manager', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1E3A8A),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Course Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Course List',
          ),
        ],
      ),
    );
  }
}

// --- Home Screen ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Welcome to the Course Management App!\n\nUse the bottom navigation to add\nor view courses.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// --- 7. & 8. Course Form Screen ---
class CourseFormScreen extends StatefulWidget {
  final Function(Course) onSave;

  const CourseFormScreen({super.key, required this.onSave});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _facultyController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _facultyController.dispose();
    _durationController.dispose();
    _feesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 10. Save the course information
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newCourse = Course(
        name: _nameController.text,
        faculty: _facultyController.text,
        duration: _durationController.text,
        fees: _feesController.text,
        description: _descriptionController.text,
      );

      widget.onSave(newCourse);

      // Clear form after saving
      _nameController.clear();
      _facultyController.clear();
      _durationController.clear();
      _feesController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course Saved Successfully!')),
      );
    }
  }

  // 9. Apply validation
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course Name', border: OutlineInputBorder()),
              validator: (value) => _validateRequired(value, 'Course Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _facultyController,
              decoration: const InputDecoration(labelText: 'Faculty Name', border: OutlineInputBorder()),
              validator: (value) => _validateRequired(value, 'Faculty Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (e.g., 6 Months)', border: OutlineInputBorder()),
              validator: (value) => _validateRequired(value, 'Duration'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _feesController,
              decoration: const InputDecoration(labelText: 'Fees', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => _validateRequired(value, 'Fees'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (value) => _validateRequired(value, 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Course', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 11. Display Courses using ListView ---
class CourseListScreen extends StatelessWidget {
  final List<Course> courses;

  const CourseListScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(
        child: Text('No courses available. Please add a course.', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A),
              child: Icon(Icons.menu_book, color: Colors.white),
            ),
            title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Faculty: ${course.faculty}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            // 12. Add onTap functionality
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: course),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// --- 13. Display Selected Course Details in a Card ---
class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${course.name} Details', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    course.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                _buildDetailRow(Icons.person, 'Faculty', course.faculty),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.access_time, 'Duration', course.duration),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.attach_money, 'Fees', course.fees),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.description, 'Description', course.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}