import 'package:flutter/material.dart';

void main() {
  runApp(CltiApp());
}

class SharedAppData {
  static int wifiStageNum = 1;
  static int glassStageNum = 1;
  static String wifiText = "Stage 1 (Çok Düşük Risk)";
  static String glassText = "Stage I (Düşük Karmaşıklık)";
}

class CltiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLTI Decision Support',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Koyu gri zemin
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFFA000), // Turuncuya yakın sarı (Amber)
          onPrimary: Colors.black,
          surface: const Color(0xFF1E1E1E), // Kartlar için koyu ton
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: '1. WIfI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '2. GLASS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: '3. PLAN',
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
  String calculatedWifiStage = "Hesaplanmadı";

  void calculateWifI() {
    int totalScore = selectedWound + selectedIschemia + selectedInfection;
    setState(() {
      if (selectedWound == 0 && selectedIschemia == 0 && selectedInfection == 0) {
        calculatedWifiStage = "Stage 1 (Çok Düşük Risk / Normal)";
        SharedAppData.wifiStageNum = 1;
      } else if (totalScore <= 2) {
        calculatedWifiStage = "Stage 1 (Çok Düşük Amputasyon Riski)";
        SharedAppData.wifiStageNum = 1;
      } else if (totalScore <= 4) {
        calculatedWifiStage = "Stage 2 (Düşük Amputasyon Riski)";
        SharedAppData.wifiStageNum = 2;
      } else if (totalScore <= 6) {
        calculatedWifiStage = "Stage 3 (Orta Amputasyon Riski)";
        SharedAppData.wifiStageNum = 3;
      } else {
        calculatedWifiStage = "Stage 4 (Yüksek Amputasyon Riski)";
        SharedAppData.wifiStageNum = 4;
      }
      SharedAppData.wifiText = calculatedWifiStage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adım 1: WIfI Limb Staging')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Yara, İskemi ve Enfeksiyon Derecelendirmesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedWound,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Wound (W - Yara / Gangren)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('Grade 0: Yara yok / Rest pain')),
                DropdownMenuItem(value: 1, child: Text('Grade 1: Küçük, sığ ülser (distal ayak)')),
                DropdownMenuItem(value: 2, child: Text('Grade 2: Kemik/eklem/tendon açıkta ülser')),
                DropdownMenuItem(value: 3, child: Text('Grade 3: Yaygın ön/orta ayak ülseri veya topuk nekrozu')),
              ],
              onChanged: (val) => setState(() => selectedWound = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedIschemia,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Ischemia (I - İskemi / Hemodinami)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('Grade 0: ABI > 0.8 | Basınç > 100 mmHg')),
                DropdownMenuItem(value: 1, child: Text('Grade 1: ABI 0.6-0.79 | Basınç 70-100 mmHg')),
                DropdownMenuItem(value: 2, child: Text('Grade 2: ABI 0.4-0.59 | Basınç 50-70 mmHg')),
                DropdownMenuItem(value: 3, child: Text('Grade 3: ABI < 0.39 | Basınç < 50 mmHg')),
              ],
              onChanged: (val) => setState(() => selectedIschemia = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedInfection,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Foot Infection (fI - Enfeksiyon)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('Grade 0: Enfeksiyon bulgusu yok')),
                DropdownMenuItem(value: 1, child: Text('Grade 1: Hafif (lokal eritem 0.5 - 2 cm)')),
                DropdownMenuItem(value: 2, child: Text('Grade 2: Orta (eritem > 2 cm veya derin doku)')),
                DropdownMenuItem(value: 3, child: Text('Grade 3: Şiddetli / Sistemik bulgulu (SIRS)')),
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
              child: Text('WIfI Evresini Hesapla ve Kaydet'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
              ),
              child: Text('Sonuç: $calculatedWifiStage\n(Otomatik olarak PLAN adımına aktarıldı.)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
            ),
          ],
        ),
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
  String calculatedGlassStage = "Hesaplanmadı";

  void calculateGlass() {
    String stage = "";
    if (fpGrade == 4 || ipGrade == 4 || (fpGrade >= 3 && ipGrade >= 2)) {
      stage = "Stage III (Yüksek Anatomik Karmaşıklık)";
      SharedAppData.glassStageNum = 3;
    } else if (fpGrade >= 2 || ipGrade >= 2) {
      stage = "Stage II (Orta Anatomik Karmaşıklık)";
      SharedAppData.glassStageNum = 2;
    } else {
      stage = "Stage I (Düşük Anatomik Karmaşıklık)";
      SharedAppData.glassStageNum = 1;
    }
    setState(() {
      calculatedGlassStage = stage;
      SharedAppData.glassText = calculatedGlassStage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adım 2: GLASS Anatomic Staging')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Anatomik Karmaşıklık Evrelemesi (GLASS)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: fpGrade,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Femoropopliteal (FP) Segment Hastalığı'),
              items: [
                DropdownMenuItem(value: 0, child: Text('FP Grade 0: Normal veya <%50 hafif darlık')),
                DropdownMenuItem(value: 1, child: Text('FP Grade 1: SFA <1/3 (<10 cm) / Kısa lezyon')),
                DropdownMenuItem(value: 2, child: Text('FP Grade 2: SFA 1/3 - 2/3 uzunluk (10-20 cm darlık)')),
                DropdownMenuItem(value: 3, child: Text('FP Grade 3: SFA >2/3 (>20 cm) uzunluk veya flush oklüzyon')),
                DropdownMenuItem(value: 4, child: Text('FP Grade 4: SFA oklüzyon >20 cm / Popliteal CTO')),
              ],
              onChanged: (val) => setState(() => fpGrade = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: ipGrade,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Infrapopliteal (IP - Hedef Arter Yolu)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('IP Grade 0: Hedef damarda normal / hafif darlık')),
                DropdownMenuItem(value: 1, child: Text('IP Grade 1: Tibial arterde odaksal stenoz (<3 cm)')),
                DropdownMenuItem(value: 2, child: Text('IP Grade 2: Damar uzunluğunun 1/3 tutulumu / <3 cm CTO')),
                DropdownMenuItem(value: 3, child: Text('IP Grade 3: Damar uzunluğunun 2/3 tutulumu / CTO')),
                DropdownMenuItem(value: 4, child: Text('IP Grade 4: Diffüz hastalık (>2/3) / Uzun CTO')),
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
              child: Text('GLASS Evresini Hesapla ve Kaydet'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
              ),
              child: Text('GLASS Sonucu: $calculatedGlassStage\n(Otomatik olarak PLAN adımına aktarıldı.)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
            ),
          ],
        ),
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
  String treatmentPlanResult = "Henüz plan oluşturulmadı";
  String referenceExplanation = "";

  void generatePlan() {
    int wifi = SharedAppData.wifiStageNum;
    int glass = SharedAppData.glassStageNum;
    String plan = "";
    String ref = "";

    if (wifi == 1) {
      plan = "Revascularization Gerekli Değil. Yara bakımı ve medikal takip yeterlidir.";
      ref = "Referans: Global Vascular Guidelines (GVG) - WIfI Stage 1 hastalarda doku kaybı riski çok düşük olduğundan acil rekonstrüksiyon endikasyonu yoktur.";
    } else if (patientRisk == "High Risk") {
      plan = "Öncelikli Strateji: Endovasküler Girişim (Minimally Invasive Endovascular Approach).";
      ref = "Referans: GVG Evreleme İlkeleri - Yüksek cerrahi riske sahip hastalarda açık cerrahi yerine endovasküler yöntemler morbiditeyi azaltır.";
    } else {
      if (glass == 3 && wifi >= 3) {
        plan = "Öncelikli Strateji: Open Bypass (Cerrahi Bypass - Otolog Ven Öncelikli).";
        ref = "Referans: GVG PLAN Algoritması - Yüksek anatomik karmaşıklık (GLASS Stage III) ve orta/yüksek limb riski (WIfI Stage 3-4) bir arada olduğunda, otolog venli cerrahi bypass altın standarttır.";
      } else {
        plan = "Öncelikli Strateji: Endovascular Intervention (Endovasküler Girişim İlk Seçenek).";
        ref = "Referans: GVG PLAN Algoritması - Düşük/Orta GLASS karmaşıklığına sahip anatomilerde endovasküler girişimler yüksek teknik başarı sunar.";
      }
    }

    setState(() {
      treatmentPlanResult = plan;
      referenceExplanation = ref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adım 3: PLAN Stratejisi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Klinik Karar ve Tedavi Planı (Otomatik Entegrasyon)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  Text('1. Adımdan Gelen WIfI: ${SharedAppData.wifiText}', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                  SizedBox(height: 5),
                  Text('2. Adımdan Gelen GLASS: ${SharedAppData.glassText}', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                ],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: patientRisk,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Hasta Cerrahi Riski (ASA / Komorbidite)'),
              items: [
                DropdownMenuItem(value: "Average Risk", child: Text('Average Risk (Standart Cerrahi Adayı)')),
                DropdownMenuItem(value: "High Risk", child: Text('High Risk (Yüksek Anestezi / Komorbidite Riski)')),
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
              child: Text('PLAN Stratejisini ve Kanıtları Üret', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text('Önerilen Tedavi Planı:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text(treatmentPlanResult, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                  SizedBox(height: 12),
                  Divider(color: Colors.grey.shade700),
                  SizedBox(height: 6),
                  Text('Kılavuz Gerekçesi ve Referanslar:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                  SizedBox(height: 4),
                  Text(referenceExplanation, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey.shade300)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
