import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedWeekId;
  List<dynamic> weeks = [];
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve user data passed from Login
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      userData = args['user'];
    }
    _loadMetadata();
  }

  void _loadMetadata() async {
    try {
      final data = await ApiService.getMetaData();
      setState(() {
        weeks = data['weeks'];
        if (weeks.isNotEmpty) {
           // Default to latest week
           selectedWeekId = weeks[0]['id'].toString();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ড্যাশবোর্ড'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'স্বাগতম, ${userData?['username'] ?? 'User'}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Week Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('সপ্তাহ নির্বাচন করুন:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedWeekId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      items: weeks.map<DropdownMenuItem<String>>((week) {
                        return DropdownMenuItem(
                          value: week['id'].toString(),
                          child: Text('${week['week_number']} সপ্তাহ (${week['end_date']})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedWeekId = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    icon: Icons.edit_document,
                    label: 'ডাটা এন্ট্রি',
                    color: Colors.orange,
                    onTap: () {
                      if (selectedWeekId == null) return;
                      Navigator.pushNamed(
                        context,
                        '/data_entry',
                        arguments: {
                          'branch_id': userData?['branch_id'],
                          'week_id': int.parse(selectedWeekId!)
                        }
                      );
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.bar_chart,
                    label: 'রিপোর্ট দেখুন',
                    color: Colors.blue,
                    onTap: () {
                      if (selectedWeekId == null) return;
                      Navigator.pushNamed(
                        context,
                        '/report_view',
                        arguments: {'week_id': int.parse(selectedWeekId!)}
                      );
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.picture_as_pdf,
                    label: 'পিডিএফ ডাউনলোড',
                    color: Colors.red,
                    onTap: () {
                       // Handled in report view or separate service
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please go to Report View to download PDF')));
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.table_view,
                    label: 'এক্সেল ডাউনলোড',
                    color: Colors.green[700]!,
                    onTap: () {
                       // Handled in report view
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please go to Report View to download Excel')));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
