import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/api_service.dart';

class DataEntryScreen extends StatefulWidget {
  const DataEntryScreen({super.key});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? branchId;
  int? weekId;
  bool _isLoading = true;

  // Data Model
  late ReportData _reportData;

  // Controllers Map to easier management
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (branchId == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        branchId = int.tryParse(args['branch_id'].toString());
        weekId = args['week_id'];
        _loadData();
      }
    }
  }

  void _loadData() async {
    if (branchId == null || weekId == null) return;
    try {
      final data = await ApiService.getReportData(branchId!, weekId!);
      setState(() {
        _reportData = data;
        _populateControllers();
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() => _isLoading = false);
    }
  }

  void _populateControllers() {
    // Helper to create/set controller
    void set(String key, dynamic value) {
      _controllers.putIfAbsent(key, () => TextEditingController()).text = value.toString();
    }

    final d = _reportData.deposits;
    set('dep_target', d.targetDeposit);
    set('dep_achv', d.achvDeposit);
    set('dep_june', d.juneBalance);
    set('dep_curr', d.achvDepositCurrWeek);
    set('dep_last', d.lastYearAchv);
    set('dep_bal', d.balanceDeposit);
    set('new_ac_target', d.targetNewAc);
    set('new_ac_achv', d.achvNewAc);
    set('scheme_target', d.targetSchemes);
    set('scheme_achv', d.achvSchemes);

    final r = _reportData.recovery;
    set('wcl1_target', r.wcl1Target);
    set('wcl1_achv', r.wcl1Achv);
    set('wcl2_target', r.wcl2Target);
    set('wcl2_achv', r.wcl2Achv);
    set('wcl3_target', r.wcl3Target);
    set('wcl3_achv', r.wcl3Achv);
    set('wcl4_target', r.wcl4Target);
    set('wcl4_achv', r.wcl4Achv);
    set('ncl_target', r.nclTarget);
    set('ncl_achv', r.nclAchv);
    set('cl_target', r.clTarget);
    set('cl_achv', r.clAchv);
    // ... Map all other fields from HTML ...
    set('double_achv', r.doubleRecoveryAchv);
    set('res_target', r.rescheduleTarget);
    set('res_achv', r.rescheduleAchv);
    set('write_target', r.writeoffTarget);
    set('write_bal', r.writeoffBalance);
    set('sus_target', r.suspense52Target);
    set('sus_achv', r.suspense52Achv);
    set('rem_target', r.remittanceTarget);
    set('rem_achv', r.remittanceAchv);
    set('out_target', r.outstandingTarget);
    set('out_bal', r.outstandingBalance);

    // Sectors - Dynamic
    for (var s in _reportData.loanSectors) {
      set('sec_target_${s.sectorCode}', s.target);
      set('sec_achv_${s.sectorCode}', s.achv);
    }

    // Ensure default sectors exist in UI if not in DB
    final defaultSectors = ['crop', 'fishery', 'livestock', 'sme', 'poverty', 'irrigation', 'agri_equip', 'seed', 'storage'];
    for (var code in defaultSectors) {
       if (!_controllers.containsKey('sec_target_$code')) {
         set('sec_target_$code', 0);
         set('sec_achv_$code', 0);
       }
    }
  }

  void _saveData() async {
    if (branchId == null || weekId == null) return;
    setState(() => _isLoading = true);

    // Update Model from Controllers
    double getD(String key) => double.tryParse(_controllers[key]?.text ?? '') ?? 0.0;
    int getI(String key) => int.tryParse(_controllers[key]?.text ?? '') ?? 0;

    _reportData.deposits
      ..targetDeposit = getD('dep_target')
      ..achvDeposit = getD('dep_achv')
      ..juneBalance = getD('dep_june')
      ..achvDepositCurrWeek = getD('dep_curr')
      ..lastYearAchv = getD('dep_last')
      ..balanceDeposit = getD('dep_bal')
      ..targetNewAc = getI('new_ac_target')
      ..achvNewAc = getI('new_ac_achv')
      ..targetSchemes = getI('scheme_target')
      ..achvSchemes = getI('scheme_achv');

    _reportData.recovery
      ..wcl1Target = getD('wcl1_target')
      ..wcl1Achv = getD('wcl1_achv')
      ..wcl2Target = getD('wcl2_target')
      ..wcl2Achv = getD('wcl2_achv')
      ..wcl3Target = getD('wcl3_target')
      ..wcl3Achv = getD('wcl3_achv')
      ..wcl4Target = getD('wcl4_target')
      ..wcl4Achv = getD('wcl4_achv')
      ..nclTarget = getD('ncl_target')
      ..nclAchv = getD('ncl_achv')
      ..clTarget = getD('cl_target')
      ..clAchv = getD('cl_achv')
      ..doubleRecoveryAchv = getD('double_achv')
      ..rescheduleTarget = getD('res_target')
      ..rescheduleAchv = getD('res_achv')
      ..writeoffTarget = getD('write_target')
      ..writeoffBalance = getD('write_bal')
      ..suspense52Target = getD('sus_target')
      ..suspense52Achv = getD('sus_achv')
      ..remittanceTarget = getD('rem_target')
      ..remittanceAchv = getD('rem_achv')
      ..outstandingTarget = getD('out_target')
      ..outstandingBalance = getD('out_bal');

    // Rebuild sectors list
    _reportData.loanSectors = [];
    final defaultSectors = ['crop', 'fishery', 'livestock', 'sme', 'poverty', 'irrigation', 'agri_equip', 'seed', 'storage'];
    for (var code in defaultSectors) {
      _reportData.loanSectors.add(LoanSectorData(
        sectorCode: code,
        target: getD('sec_target_$code'),
        achv: getD('sec_achv_$code')
      ));
    }

    try {
      await ApiService.submitReport(branchId!, weekId!, _reportData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ডাটা সফলভাবে সংরক্ষণ করা হয়েছে!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ডাটা এন্ট্রি ফর্ম'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'আমানত'),
            Tab(text: 'ঋণ খাত'),
            Tab(text: 'আদায়'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDepositTab(),
          _buildLoanTab(),
          _buildRecoveryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveData,
        label: const Text('সংরক্ষণ করুন'),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDepositTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('আমানত সংগ্রহ (Deposit Collection)'),
          _buildRowInput('জুন/২৫ স্থিতি', 'dep_june', 'লক্ষ্যমাত্রা', 'dep_target'),
          _buildRowInput('অর্জন (Achv)', 'dep_achv', 'চলতি সপ্তাহে', 'dep_curr'),
          _buildRowInput('গত বছর অর্জন', 'dep_last', 'আমানত স্থিতি', 'dep_bal'),

          const SizedBox(height: 20),
          _buildSectionHeader('নতুন আমানত হিসাব খোলা'),
          _buildRowInput('লক্ষ্যমাত্রা', 'new_ac_target', 'অর্জন', 'new_ac_achv'),

          const SizedBox(height: 20),
          _buildSectionHeader('৬টি আকর্ষণীয় স্কীম'),
          _buildRowInput('লক্ষ্যমাত্রা', 'scheme_target', 'অর্জন', 'scheme_achv'),
        ],
      ),
    );
  }

  Widget _buildLoanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('শস্য (Crop)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_crop', 'অর্জন', 'sec_achv_crop'),

          _buildSectionHeader('মৎস্য (Fishery)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_fishery', 'অর্জন', 'sec_achv_fishery'),

          _buildSectionHeader('প্রাণী সম্পদ (Livestock)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_livestock', 'অর্জন', 'sec_achv_livestock'),

          _buildSectionHeader('সেচ (Irrigation)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_irrigation', 'অর্জন', 'sec_achv_irrigation'),

          _buildSectionHeader('কৃষি যন্ত্রপাতি (Agri Equip)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_agri_equip', 'অর্জন', 'sec_achv_agri_equip'),

          _buildSectionHeader('এসএমই (SME)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_sme', 'অর্জন', 'sec_achv_sme'),

          _buildSectionHeader('দারিদ্র বিমোচন (Poverty)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sec_target_poverty', 'অর্জন', 'sec_achv_poverty'),
        ],
      ),
    );
  }

  Widget _buildRecoveryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('WCL-1'),
          _buildRowInput('লক্ষ্যমাত্রা', 'wcl1_target', 'অর্জন', 'wcl1_achv'),

          _buildSectionHeader('WCL-2'),
          _buildRowInput('লক্ষ্যমাত্রা', 'wcl2_target', 'অর্জন', 'wcl2_achv'),

          _buildSectionHeader('WCL-3'),
          _buildRowInput('লক্ষ্যমাত্রা', 'wcl3_target', 'অর্জন', 'wcl3_achv'),

          _buildSectionHeader('WCL-4'),
          _buildRowInput('লক্ষ্যমাত্রা', 'wcl4_target', 'অর্জন', 'wcl4_achv'),

          _buildSectionHeader('NCL'),
          _buildRowInput('লক্ষ্যমাত্রা', 'ncl_target', 'অর্জন', 'ncl_achv'),

          _buildSectionHeader('CL'),
          _buildRowInput('লক্ষ্যমাত্রা', 'cl_target', 'অর্জন', 'cl_achv'),

          _buildSectionHeader('দ্বিগুণ আদায় (Double)'),
          _buildSingleInput('অর্জন', 'double_achv'),

          _buildSectionHeader('রিসিডিউল (Reschedule)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'res_target', 'অর্জন', 'res_achv'),

          _buildSectionHeader('অবলোপন (Write-off)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'write_target', 'স্থিতি', 'write_bal'),

          _buildSectionHeader('৫২-সুদ (Suspense)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'sus_target', 'অর্জন', 'sus_achv'),

          _buildSectionHeader('রেমিট্যান্স (Remittance)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'rem_target', 'অর্জন', 'rem_achv'),

          _buildSectionHeader('অনাদায়ী স্থিতি (Outstanding)'),
          _buildRowInput('লক্ষ্যমাত্রা', 'out_target', 'স্থিতি', 'out_bal'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildRowInput(String label1, String key1, String label2, String key2) {
    return Row(
      children: [
        Expanded(child: _buildSingleInput(label1, key1)),
        const SizedBox(width: 10),
        Expanded(child: _buildSingleInput(label2, key2)),
      ],
    );
  }

  Widget _buildSingleInput(String label, String key) {
    // Ensure controller exists
    _controllers.putIfAbsent(key, () => TextEditingController());
    return TextField(
      controller: _controllers[key],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
