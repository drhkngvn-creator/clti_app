import 'package:flutter/material.dart';

void main() {
  runApp(CltiApp());
}

// Uygulama genelinde dil ve veri yönetimi
class AppData {
  static bool isEnglish = true; // Varsayılan İngilizce
  static int wifiStageNum = 1;
  static int glassStageNum = 1;
  static String wifiTextEn = "Stage 1 (Very Low Risk)";
  static String wifiTextTr = "Stage 1 (Çok Düşük Risk)";
  static String glassTextEn = "Stage I (Low Complexity)";
  static String glassTextTr = "Stage I (Düşük Karmaşıklık)";
}

class CltiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLTI Decision Support',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFFA000),
          onPrimary: Colors.black,
          surface: const Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    WifiCalculatorScreen(),
    GlassCalculatorScreen(),
    PlanStrategyScreen(),
  ];

  void _toggleLanguage() {
    setState(() {
      AppData.isEnglish = !AppData.isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppData.isEnglish ? 'CLTI Decision Support' : 'CLTI Karar Destek'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            tooltip: AppData.isEnglish ? 'Türkçeye Geç' : 'Switch to English',
            onPressed: _toggleLanguage,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                AppData.isEnglish ? 'EN' : 'TR',
                style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFFA000),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.healing),
            label: AppData.isEnglish ? '1. WIfI' : '1. WIfI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: AppData.isEnglish ? '2. GLASS' : '2. GLASS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: AppData.isEnglish ? '3. PLAN' : '3. PLAN',
          ),
        ],
      ),
    );
  }
}

class WifiCalculatorScreen extends StatefulWidget {
  @override
  _WifiCalculatorScreenState createState() => _WifiCalculatorScreenState();
}

class _WifiCalculatorScreenState extends State<WifiCalculatorScreen> {
  int selectedWound = 0;
  int selectedIschemia = 0;
  int selectedInfection = 0;
  String calculatedWifiEn = "Not Calculated";
  String calculatedWifiTr = "Hesaplanmadı";

  void calculateWifI() {
    int totalScore = selectedWound + selectedIschemia + selectedInfection;
    setState(() {
      if (selectedWound == 0 && selectedIschemia == 0 && selectedInfection == 0) {
        calculatedWifiEn = "Stage 1 (Very Low Risk / Normal)";
        calculatedWifiTr = "Stage 1 (Çok Düşük Risk / Normal)";
        AppData.wifiStageNum = 1;
      } else if (totalScore <= 2) {
        calculatedWifiEn = "Stage 1 (Very Low Amputation Risk)";
        calculatedWifiTr = "Stage 1 (Çok Düşük Amputasyon Riski)";
        AppData.wifiStageNum = 1;
      } else if (totalScore <= 4) {
        calculatedWifiEn = "Stage 2 (Low Amputation Risk)";
        calculatedWifiTr = "Stage 2 (Düşük Amputasyon Riski)";
        AppData.wifiStageNum = 2;
      } else if (totalScore <= 6) {
        calculatedWifiEn = "Stage 3 (Moderate Amputation Risk)";
        calculatedWifiTr = "Stage 3 (Orta Amputasyon Riski)";
        AppData.wifiStageNum = 3;
      } else {
        calculatedWifiEn = "Stage 4 (High Amputation Risk)";
        calculatedWifiTr = "Stage 4 (Yüksek Amputasyon Riski)";
        AppData.wifiStageNum = 4;
      }
      AppData.wifiTextEn = calculatedWifiEn;
      AppData.wifiTextTr = calculatedWifiTr;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool en = AppData.isEnglish;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            en ? 'Wound, Ischemia, and foot Infection Grading' : 'Yara, İskemi ve Enfeksiyon Derecelendirmesi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: selectedWound,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Wound (W)' : 'Yara (W)'),
            items: [
              DropdownMenuItem(value: 0, child: Text(en ? 'Grade 0: No ulcer / Rest pain' : 'Grade 0: Yara yok / İstirahat ağrısı')),
              DropdownMenuItem(value: 1, child: Text(en ? 'Grade 1: Small, shallow ulcer (distal)' : 'Grade 1: Küçük, sığ ülser (distal)')),
              DropdownMenuItem(value: 2, child: Text(en ? 'Grade 2: Deeper ulcer with exposed bone/tendon' : 'Grade 2: Kemik/tendon açıkta derin ülser')),
              DropdownMenuItem(value: 3, child: Text(en ? 'Grade 3: Extensive forefoot/midfoot ulcer or calcaneal necrosis' : 'Grade 3: Yaygın ön/orta ayak ülseri veya topuk nekrozu')),
            ],
            onChanged: (val) => setState(() => selectedWound = val!),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: selectedIschemia,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Ischemia (I)' : 'İskemi (I)'),
            items: [
              DropdownMenuItem(value: 0, child: Text('Grade 0: ABI > 0.8 | Pressure > 100 mmHg')),
              DropdownMenuItem(value: 1, child: Text('Grade 1: ABI 0.6-0.79 | Pressure 70-100 mmHg')),
              DropdownMenuItem(value: 2, child: Text('Grade 2: ABI 0.4-0.59 | Pressure 50-70 mmHg')),
              DropdownMenuItem(value: 3, child: Text('Grade 3: ABI < 0.39 | Pressure < 50 mmHg')),
            ],
            onChanged: (val) => setState(() => selectedIschemia = val!),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: selectedInfection,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Foot Infection (fI)' : 'Ayak Enfeksiyonu (fI)'),
            items: [
              DropdownMenuItem(value: 0, child: Text(en ? 'Grade 0: No symptoms of infection' : 'Grade 0: Enfeksiyon bulgusu yok')),
              DropdownMenuItem(value: 1, child: Text(en ? 'Grade 1: Mild (local erythema 0.5 - 2 cm)' : 'Grade 1: Hafif (lokal eritem 0.5 - 2 cm)')),
              DropdownMenuItem(value: 2, child: Text(en ? 'Grade 2: Moderate (erythema > 2 cm or deeper tissue)' : 'Grade 2: Orta (eritem > 2 cm veya derin doku)')),
              DropdownMenuItem(value: 3, child: Text(en ? 'Grade 3: Severe / Systemic inflammatory response (SIRS)' : 'Grade 3: Şiddetli / Sistemik bulgulu (SIRS)')),
            ],
            onChanged: (val) => setState(() => selectedInfection = val!),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA000),
              foregroundColor: Colors.black,
            ),
            onPressed: calculateWifI,
            child: Text(en ? 'Calculate & Save WIfI Stage' : 'WIfI Evresini Hesapla ve Kaydet'),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
            ),
            child: Text(
              en
                  ? 'Result: $calculatedWifiEn\n(Automatically transferred to PLAN step.)'
                  : 'Sonuç: $calculatedWifiTr\n(Otomatik olarak PLAN adımına aktarıldı.)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassCalculatorScreen extends StatefulWidget {
  @override
  _GlassCalculatorScreenState createState() => _GlassCalculatorScreenState();
}

class _GlassCalculatorScreenState extends State<GlassCalculatorScreen> {
  int fpGrade = 0;
  int ipGrade = 0;
  String calculatedGlassEn = "Not Calculated";
  String calculatedGlassTr = "Hesaplanmadı";

  void calculateGlass() {
    String stageEn = "";
    String stageTr = "";
    if (fpGrade == 4 || ipGrade == 4 || (fpGrade >= 3 && ipGrade >= 2)) {
      stageEn = "Stage III (High Anatomic Complexity)";
      stageTr = "Stage III (Yüksek Anatomik Karmaşıklık)";
      AppData.glassStageNum = 3;
    } else if (fpGrade >= 2 || ipGrade >= 2) {
      stageEn = "Stage II (Intermediate Anatomic Complexity)";
      stageTr = "Stage II (Orta Anatomik Karmaşıklık)";
      AppData.glassStageNum = 2;
    } else {
      stageEn = "Stage I (Low Anatomic Complexity)";
      stageTr = "Stage I (Düşük Anatomik Karmaşıklık)";
      AppData.glassStageNum = 1;
    }
    setState(() {
      calculatedGlassEn = stageEn;
      calculatedGlassTr = stageTr;
      AppData.glassTextEn = calculatedGlassEn;
      AppData.glassTextTr = calculatedGlassTr;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool en = AppData.isEnglish;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            en ? 'Global Anatomic Staging System (GLASS)' : 'Global Anatomik Evreleme Sistemi (GLASS)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: fpGrade,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Femoropopliteal (FP) Segment' : 'Femoropopliteal (FP) Segmenti'),
            items: [
              DropdownMenuItem(value: 0, child: Text(en ? 'FP Grade 0: Normal or <50% stenosis' : 'FP Grade 0: Normal veya <%50 darlık')),
              DropdownMenuItem(value: 1, child: Text(en ? 'FP Grade 1: SFA <1/3 (<10 cm) / Short lesion' : 'FP Grade 1: SFA <1/3 (<10 cm) / Kısa lezyon')),
              DropdownMenuItem(value: 2, child: Text(en ? 'FP Grade 2: SFA 1/3 - 2/3 length (10-20 cm)' : 'FP Grade 2: SFA 1/3 - 2/3 uzunluk (10-20 cm)')),
              DropdownMenuItem(value: 3, child: Text(en ? 'FP Grade 3: SFA >2/3 (>20 cm) or flush occlusion' : 'FP Grade 3: SFA >2/3 (>20 cm) veya flush oklüzyon')),
              DropdownMenuItem(value: 4, child: Text(en ? 'FP Grade 4: SFA occlusion >20 cm / Popliteal CTO' : 'FP Grade 4: SFA oklüzyon >20 cm / Popliteal CTO')),
            ],
            onChanged: (val) => setState(() => fpGrade = val!),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: ipGrade,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Infrapopliteal (IP) Segment' : 'İnfrapopliteal (IP) Segmenti'),
            items: [
              DropdownMenuItem(value: 0, child: Text(en ? 'IP Grade 0: Normal / minimal disease' : 'IP Grade 0: Normal / minimal hastalık')),
              DropdownMenuItem(value: 1, child: Text(en ? 'IP Grade 1: Focal tibial stenosis (<3 cm)' : 'IP Grade 1: Odaksal tibial stenoz (<3 cm)')),
              DropdownMenuItem(value: 2, child: Text(en ? 'IP Grade 2: 1/3 vessel involvement / <3 cm CTO' : 'IP Grade 2: 1/3 damar tutulumu / <3 cm CTO')),
              DropdownMenuItem(value: 3, child: Text(en ? 'IP Grade 3: 2/3 vessel involvement / CTO' : 'IP Grade 3: 2/3 damar tutulumu / CTO')),
              DropdownMenuItem(value: 4, child: Text(en ? 'IP Grade 4: Diffuse disease (>2/3) / Long CTO' : 'IP Grade 4: Diffüz hastalık (>2/3) / Uzun CTO')),
            ],
            onChanged: (val) => setState(() => ipGrade = val!),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA000),
              foregroundColor: Colors.black,
            ),
            onPressed: calculateGlass,
            child: Text(en ? 'Calculate & Save GLASS Stage' : 'GLASS Evresini Hesapla ve Kaydet'),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
            ),
            child: Text(
              en
                  ? 'GLASS Result: $calculatedGlassEn\n(Automatically transferred to PLAN step.)'
                  : 'GLASS Sonucu: $calculatedGlassTr\n(Otomatik olarak PLAN adımına aktarıldı.)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanStrategyScreen extends StatefulWidget {
  @override
  _PlanStrategyScreenState createState() => _PlanStrategyScreenState();
}

class _PlanStrategyScreenState extends State<PlanStrategyScreen> {
  String patientRisk = "Average Risk";
  String treatmentPlanEn = "No plan generated yet";
  String treatmentPlanTr = "Henüz plan oluşturulmadı";
  String referenceEn = "";
  String referenceTr = "";

  void generatePlan() {
    int wifi = AppData.wifiStageNum;
    int glass = AppData.glassStageNum;

    if (wifi == 1) {
      treatmentPlanEn = "Revascularization Not Required. Wound care and medical treatment are sufficient.";
      treatmentPlanTr = "Revaskülarizasyon Gerekli Değil. Yara bakımı ve medikal tedavi yeterlidir.";
      referenceEn = "Reference: Global Vascular Guidelines (GVG) - WIfI Stage 1 patients have a very low risk of tissue loss, hence urgent reconstruction is not indicated.";
      referenceTr = "Referans: Global Vascular Guidelines (GVG) - WIfI Evre 1 hastalarda doku kaybı riski çok düşük olduğundan acil rekonstrüksiyon endikasyonu yoktur.";
    } else if (patientRisk == "High Risk") {
      treatmentPlanEn = "Primary Strategy: Minimally Invasive Endovascular Approach.";
      treatmentPlanTr = "Öncelikli Strateji: Minimal İnvaziv Endovasküler Yaklaşım.";
      referenceEn = "Reference: GVG Staging Principles - Endovascular interventions reduce morbidity compared to open surgery in high surgical risk patients.";
      referenceTr = "Referans: GVG Evreleme İlkeleri - Yüksek cerrahi riske sahip hastalarda endovasküler girişimler açık cerrahiye göre morbiditeyi azaltır.";
    } else {
      if (glass == 3 && wifi >= 3) {
        treatmentPlanEn = "Primary Strategy: Open Surgical Bypass (Autologous Vein Preferred).";
        treatmentPlanTr = "Öncelikli Strateji: Cerrahi Bypass (Otolog Ven Öncelikli).";
        referenceEn = "Reference: GVG PLAN Algorithm - When high anatomic complexity (GLASS Stage III) and moderate/high limb risk (WIfI Stage 3-4) coexist, open bypass with autologous vein is the gold standard.";
        referenceTr = "Referans: GVG PLAN Algoritması - Yüksek anatomik karmaşıklık (GLASS Evre III) ve orta/yüksek limb riski (WIfI Evre 3-4) bir arada olduğunda otolog venli cerrahi bypass altın standarttır.";
      } else {
        treatmentPlanEn = "Primary Strategy: Endovascular Intervention First Choice.";
        treatmentPlanTr = "Öncelikli Strateji: İlk Seçenek Endovasküler Girişim.";
        referenceEn = "Reference: GVG PLAN Algorithm - Endovascular options offer high technical success rates in low/moderate GLASS anatomic complexities.";
        referenceTr = "Referans: GVG PLAN Algoritması - Düşük/Orta GLASS karmaşıklığına sahip anatomilerde endovasküler girişimler yüksek teknik başarı sunar.";
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool en = AppData.isEnglish;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            en ? 'Clinical Decision & Treatment Plan (Auto-Integrated)' : 'Klinik Karar ve Tedavi Planı (Otomatik Entegrasyon)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  en ? 'WIfI from Step 1: ${AppData.wifiTextEn}' : '1. Adımdan Gelen WIfI: ${AppData.wifiTextTr}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
                ),
                SizedBox(height: 5),
                Text(
                  en ? 'GLASS from Step 2: ${AppData.glassTextEn}' : '2. Adımdan Gelen GLASS: ${AppData.glassTextTr}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: patientRisk,
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(labelText: en ? 'Patient Surgical Risk (ASA / Comorbidity)' : 'Hasta Cerrahi Riski (ASA / Komorbidite)'),
            items: [
              DropdownMenuItem(value: "Average Risk", child: Text(en ? 'Average Risk (Standard Surgical Candidate)' : 'Average Risk (Standart Cerrahi Adayı)')),
              DropdownMenuItem(value: "High Risk", child: Text(en ? 'High Risk (High Anesthesia / Comorbidity Risk)' : 'High Risk (Yüksek Anestezi / Komorbidite Riski)')),
            ],
            onChanged: (val) => setState(() => patientRisk = val!),
          ),
          SizedBox(height: 30),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA000),
              foregroundColor: Colors.black,
            ),
            onPressed: generatePlan,
            child: Text(
              en ? 'Generate PLAN Strategy & Evidence' : 'PLAN Stratejisini ve Kanıtları Üret',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  en ? 'Recommended Treatment Plan:' : 'Önerilen Tedavi Planı:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  en ? treatmentPlanEn : treatmentPlanTr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000)),
                ),
                SizedBox(height: 12),
                Divider(color: Colors.grey.shade700),
                SizedBox(height: 6),
                Text(
                  en ? 'Guideline Rationale & References:' : 'Kılavuz Gerekçesi ve Referanslar:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                ),
                SizedBox(height: 4),
                Text(
                  en ? referenceEn : referenceTr,
                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
