class ReportData {
  DepositData deposits;
  RecoveryData recovery;
  List<LoanSectorData> loanSectors;
  LoanGeneralData loanGeneral;

  ReportData({
    required this.deposits,
    required this.recovery,
    required this.loanSectors,
    required this.loanGeneral,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      deposits: DepositData.fromJson(json['deposits'] ?? {}),
      recovery: RecoveryData.fromJson(json['recovery'] ?? {}),
      loanSectors: (json['loan_sectors'] as List?)
              ?.map((e) => LoanSectorData.fromJson(e))
              .toList() ??
          [],
      loanGeneral: LoanGeneralData.fromJson(json['loan_general'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'deposits': deposits.toJson(),
        'recovery': recovery.toJson(),
        'loan_sectors': loanSectors.map((e) => e.toJson()).toList(),
        'loan_general': loanGeneral.toJson(),
      };
}

class DepositData {
  double juneBalance;
  double targetDeposit;
  double achvDeposit;
  double achvDepositCurrWeek;
  double lastYearAchv;
  double balanceDeposit;
  int targetNewAc;
  int achvNewAc;
  int targetSchemes;
  int achvSchemes;

  DepositData({
    this.juneBalance = 0.0,
    this.targetDeposit = 0.0,
    this.achvDeposit = 0.0,
    this.achvDepositCurrWeek = 0.0,
    this.lastYearAchv = 0.0,
    this.balanceDeposit = 0.0,
    this.targetNewAc = 0,
    this.achvNewAc = 0,
    this.targetSchemes = 0,
    this.achvSchemes = 0,
  });

  factory DepositData.fromJson(Map<String, dynamic> json) {
    return DepositData(
      juneBalance: double.tryParse(json['june_balance'].toString()) ?? 0.0,
      targetDeposit: double.tryParse(json['target_deposit'].toString()) ?? 0.0,
      achvDeposit: double.tryParse(json['achv_deposit'].toString()) ?? 0.0,
      achvDepositCurrWeek:
          double.tryParse(json['achv_deposit_curr_week'].toString()) ?? 0.0,
      lastYearAchv: double.tryParse(json['last_year_achv'].toString()) ?? 0.0,
      balanceDeposit:
          double.tryParse(json['balance_deposit'].toString()) ?? 0.0,
      targetNewAc: int.tryParse(json['target_new_ac'].toString()) ?? 0,
      achvNewAc: int.tryParse(json['achv_new_ac'].toString()) ?? 0,
      targetSchemes: int.tryParse(json['target_schemes'].toString()) ?? 0,
      achvSchemes: int.tryParse(json['achv_schemes'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'june_balance': juneBalance,
        'target_deposit': targetDeposit,
        'achv_deposit': achvDeposit,
        'achv_deposit_curr_week': achvDepositCurrWeek,
        'last_year_achv': lastYearAchv,
        'balance_deposit': balanceDeposit,
        'target_new_ac': targetNewAc,
        'achv_new_ac': achvNewAc,
        'target_schemes': targetSchemes,
        'achv_schemes': achvSchemes,
      };
}

class RecoveryData {
  double wcl1Target;
  double wcl1Achv;
  double wcl2Target;
  double wcl2Achv;
  double wcl3Target;
  double wcl3Achv;
  double wcl4Target;
  double wcl4Achv;
  double nclTarget;
  double nclAchv;
  double clTarget;
  double clAchv;
  double doubleRecoveryAchv;
  double rescheduleTarget;
  double rescheduleAchv;
  double writeoffTarget;
  double writeoffBalance;
  double suspense52Target;
  double suspense52Achv;
  double remittanceTarget;
  double remittanceAchv;
  double outstandingTarget;
  double outstandingBalance;

  RecoveryData({
    this.wcl1Target = 0.0,
    this.wcl1Achv = 0.0,
    this.wcl2Target = 0.0,
    this.wcl2Achv = 0.0,
    this.wcl3Target = 0.0,
    this.wcl3Achv = 0.0,
    this.wcl4Target = 0.0,
    this.wcl4Achv = 0.0,
    this.nclTarget = 0.0,
    this.nclAchv = 0.0,
    this.clTarget = 0.0,
    this.clAchv = 0.0,
    this.doubleRecoveryAchv = 0.0,
    this.rescheduleTarget = 0.0,
    this.rescheduleAchv = 0.0,
    this.writeoffTarget = 0.0,
    this.writeoffBalance = 0.0,
    this.suspense52Target = 0.0,
    this.suspense52Achv = 0.0,
    this.remittanceTarget = 0.0,
    this.remittanceAchv = 0.0,
    this.outstandingTarget = 0.0,
    this.outstandingBalance = 0.0,
  });

  factory RecoveryData.fromJson(Map<String, dynamic> json) {
    return RecoveryData(
      wcl1Target: double.tryParse(json['wcl_1_target'].toString()) ?? 0.0,
      wcl1Achv: double.tryParse(json['wcl_1_achv'].toString()) ?? 0.0,
      wcl2Target: double.tryParse(json['wcl_2_target'].toString()) ?? 0.0,
      wcl2Achv: double.tryParse(json['wcl_2_achv'].toString()) ?? 0.0,
      wcl3Target: double.tryParse(json['wcl_3_target'].toString()) ?? 0.0,
      wcl3Achv: double.tryParse(json['wcl_3_achv'].toString()) ?? 0.0,
      wcl4Target: double.tryParse(json['wcl_4_target'].toString()) ?? 0.0,
      wcl4Achv: double.tryParse(json['wcl_4_achv'].toString()) ?? 0.0,
      nclTarget: double.tryParse(json['ncl_target'].toString()) ?? 0.0,
      nclAchv: double.tryParse(json['ncl_achv'].toString()) ?? 0.0,
      clTarget: double.tryParse(json['cl_target'].toString()) ?? 0.0,
      clAchv: double.tryParse(json['cl_achv'].toString()) ?? 0.0,
      doubleRecoveryAchv:
          double.tryParse(json['double_recovery_achv'].toString()) ?? 0.0,
      rescheduleTarget:
          double.tryParse(json['reschedule_target'].toString()) ?? 0.0,
      rescheduleAchv:
          double.tryParse(json['reschedule_achv'].toString()) ?? 0.0,
      writeoffTarget:
          double.tryParse(json['writeoff_target'].toString()) ?? 0.0,
      writeoffBalance:
          double.tryParse(json['writeoff_balance'].toString()) ?? 0.0,
      suspense52Target:
          double.tryParse(json['suspense_52_target'].toString()) ?? 0.0,
      suspense52Achv:
          double.tryParse(json['suspense_52_achv'].toString()) ?? 0.0,
      remittanceTarget:
          double.tryParse(json['remittance_target'].toString()) ?? 0.0,
      remittanceAchv:
          double.tryParse(json['remittance_achv'].toString()) ?? 0.0,
      outstandingTarget:
          double.tryParse(json['outstanding_target'].toString()) ?? 0.0,
      outstandingBalance:
          double.tryParse(json['outstanding_balance'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'wcl_1_target': wcl1Target,
        'wcl_1_achv': wcl1Achv,
        'wcl_2_target': wcl2Target,
        'wcl_2_achv': wcl2Achv,
        'wcl_3_target': wcl3Target,
        'wcl_3_achv': wcl3Achv,
        'wcl_4_target': wcl4Target,
        'wcl_4_achv': wcl4Achv,
        'ncl_target': nclTarget,
        'ncl_achv': nclAchv,
        'cl_target': clTarget,
        'cl_achv': clAchv,
        'double_recovery_achv': doubleRecoveryAchv,
        'reschedule_target': rescheduleTarget,
        'reschedule_achv': rescheduleAchv,
        'writeoff_target': writeoffTarget,
        'writeoff_balance': writeoffBalance,
        'suspense_52_target': suspense52Target,
        'suspense_52_achv': suspense52Achv,
        'remittance_target': remittanceTarget,
        'remittance_achv': remittanceAchv,
        'outstanding_target': outstandingTarget,
        'outstanding_balance': outstandingBalance,
      };
}

class LoanSectorData {
  String sectorCode;
  double target;
  double achv;

  LoanSectorData({
    required this.sectorCode,
    this.target = 0.0,
    this.achv = 0.0,
  });

  factory LoanSectorData.fromJson(Map<String, dynamic> json) {
    return LoanSectorData(
      sectorCode: json['sector_code'] ?? '',
      target: double.tryParse(json['target'].toString()) ?? 0.0,
      achv: double.tryParse(json['achv'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'sector_code': sectorCode,
        'target': target,
        'achv': achv,
      };
}

class LoanGeneralData {
  int borrowersJuneBalance;
  int borrowersTarget;
  int borrowersCurr;
  double nclStatusBalance;
  double nclStatusTarget;
  double ratioDepositBalance;
  double ratioLoanBalance;

  LoanGeneralData({
    this.borrowersJuneBalance = 0,
    this.borrowersTarget = 0,
    this.borrowersCurr = 0,
    this.nclStatusBalance = 0.0,
    this.nclStatusTarget = 0.0,
    this.ratioDepositBalance = 0.0,
    this.ratioLoanBalance = 0.0,
  });

  factory LoanGeneralData.fromJson(Map<String, dynamic> json) {
    return LoanGeneralData(
      borrowersJuneBalance:
          int.tryParse(json['borrowers_june_balance'].toString()) ?? 0,
      borrowersTarget:
          int.tryParse(json['borrowers_target'].toString()) ?? 0,
      borrowersCurr: int.tryParse(json['borrowers_curr'].toString()) ?? 0,
      nclStatusBalance:
          double.tryParse(json['ncl_status_balance'].toString()) ?? 0.0,
      nclStatusTarget:
          double.tryParse(json['ncl_status_target'].toString()) ?? 0.0,
      ratioDepositBalance:
          double.tryParse(json['ratio_deposit_balance'].toString()) ?? 0.0,
      ratioLoanBalance:
          double.tryParse(json['ratio_loan_balance'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'borrowers_june_balance': borrowersJuneBalance,
        'borrowers_target': borrowersTarget,
        'borrowers_curr': borrowersCurr,
        'ncl_status_balance': nclStatusBalance,
        'ncl_status_target': nclStatusTarget,
        'ratio_deposit_balance': ratioDepositBalance,
        'ratio_loan_balance': ratioLoanBalance,
      };
}
