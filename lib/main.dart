import 'package:flutter/material.dart';

void main() {
  runApp(CltiApp());
}

class SharedAppData {
  static int wifiStageNum = 1;
  static int glassStageNum = 1;
  static String wifiText = "Stage 1 (Very Low Risk)";
  static String glassText = "Stage I (Low Complexity)";
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
  String calculatedWifiStage = "Not Calculated";

  void calculateWifI() {
    int totalScore = selectedWound + selectedIschemia + selectedInfection;
    setState(() {
      if (selectedWound == 0 && selectedIschemia == 0 && selectedInfection == 0) {
        calculatedWifiStage = "Stage 1 (Very Low Risk / Normal)";
        SharedAppData.wifiStageNum = 1;
      } else if (totalScore <= 2) {
        calculatedWifiStage = "Stage 1 (Very Low Amputation Risk)";
        SharedAppData.wifiStageNum = 1;
      } else if (totalScore <= 4) {
        calculatedWifiStage = "Stage 2 (Low Amputation Risk)";
        SharedAppData.wifiStageNum = 2;
      } else if (totalScore <= 6) {
        calculatedWifiStage = "Stage 3 (Moderate Amputation Risk)";
        SharedAppData.wifiStageNum = 3;
      } else {
        calculatedWifiStage = "Stage 4 (High Amputation Risk)";
        SharedAppData.wifiStageNum = 4;
      }
      SharedAppData.wifiText = calculatedWifiStage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Step 1: WIfI Limb Staging')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Wound, Ischemia, and foot Infection Grading', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedWound,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Wound (W)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('Grade 0: No ulcer / Rest pain')),
                DropdownMenuItem(value: 1, child: Text('Grade 1: Small, shallow ulcer (distal)')),
                DropdownMenuItem(value: 2, child: Text('Grade 2: Deeper ulcer with exposed bone/tendon')),
                DropdownMenuItem(value: 3, child: Text('Grade 3: Extensive forefoot/midfoot ulcer or calcaneal necrosis')),
              ],
              onChanged: (val) => setState(() => selectedWound = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedIschemia,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Ischemia (I)'),
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
              decoration: InputDecoration(labelText: 'Foot Infection (fI)'),
              items: [
                DropdownMenuItem(value: 0, child: Text('Grade 0: No symptoms of infection')),
                DropdownMenuItem(value: 1, child: Text('Grade 1: Mild (local erythema 0.5 - 2 cm)')),
                DropdownMenuItem(value: 2, child: Text('Grade 2: Moderate (erythema > 2 cm or deeper tissue)')),
                DropdownMenuItem(value: 3, child: Text('Grade 3: Severe / Systemic inflammatory response (SIRS)')),
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
              child: Text('Calculate & Save WIfI Stage'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
              ),
              child: Text('Result: $calculatedWifiStage\n(Automatically transferred to PLAN step.)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
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
  String calculatedGlassStage = "Not Calculated";

  void calculateGlass() {
    String stage = "";
    if (fpGrade == 4 || ipGrade == 4 || (fpGrade >= 3 && ipGrade >= 2)) {
      stage = "Stage III (High Anatomic Complexity)";
      SharedAppData.glassStageNum = 3;
    } else if (fpGrade >= 2 || ipGrade >= 2) {
      stage = "Stage II (Intermediate Anatomic Complexity)";
      SharedAppData.glassStageNum = 2;
    } else {
      stage = "Stage I (Low Anatomic Complexity)";
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
      appBar: AppBar(title: Text('Step 2: GLASS Anatomic Staging')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Global Anatomic Staging System (GLASS)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: fpGrade,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Femoropopliteal (FP) Segment'),
              items: [
                DropdownMenuItem(value: 0, child: Text('FP Grade 0: Normal or <50% stenosis')),
                DropdownMenuItem(value: 1, child: Text('FP Grade 1: SFA <1/3 (<10 cm) / Short lesion')),
                DropdownMenuItem(value: 2, child: Text('FP Grade 2: SFA 1/3 - 2/3 length (10-20 cm)')),
                DropdownMenuItem(value: 3, child: Text('FP Grade 3: SFA >2/3 (>20 cm) or flush occlusion')),
                DropdownMenuItem(value: 4, child: Text('FP Grade 4: SFA occlusion >20 cm / Popliteal CTO')),
              ],
              onChanged: (val) => setState(() => fpGrade = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: ipGrade,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Infrapopliteal (IP) Segment'),
              items: [
                DropdownMenuItem(value: 0, child: Text('IP Grade 0: Normal / minimal disease')),
                DropdownMenuItem(value: 1, child: Text('IP Grade 1: Focal tibial stenosis (<3 cm)')),
                DropdownMenuItem(value: 2, child: Text('IP Grade 2: 1/3 vessel involvement / <3 cm CTO')),
                DropdownMenuItem(value: 3, child: Text('IP Grade 3: 2/3 vessel involvement / CTO')),
                DropdownMenuItem(value: 4, child: Text('IP Grade 4: Diffuse disease (>2/3) / Long CTO')),
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
              child: Text('Calculate & Save GLASS Stage'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.5)),
              ),
              child: Text('GLASS Result: $calculatedGlassStage\n(Automatically transferred to PLAN step.)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
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
  String treatmentPlanResult = "No plan generated yet";
  String referenceExplanation = "";

  void generatePlan() {
    int wifi = SharedAppData.wifiStageNum;
    int glass = SharedAppData.glassStageNum;
    String plan = "";
    String ref = "";

    if (wifi == 1) {
      plan = "Revascularization Not Required. Wound care and medical treatment are sufficient.";
      ref = "Reference: Global Vascular Guidelines (GVG) - WIfI Stage 1 patients have a very low risk of tissue loss, hence urgent reconstruction is not indicated.";
    } else if (patientRisk == "High Risk") {
      plan = "Primary Strategy: Minimally Invasive Endovascular Approach.";
      ref = "Reference: GVG Staging Principles - Endovascular interventions reduce morbidity compared to open surgery in high surgical risk patients.";
    } else {
      if (glass == 3 && wifi >= 3) {
        plan = "Primary Strategy: Open Surgical Bypass (Autologous Vein Preferred).";
        ref = "Reference: GVG PLAN Algorithm - When high anatomic complexity (GLASS Stage III) and moderate/high limb risk (WIfI Stage 3-4) coexist, open bypass with autologous vein is the gold standard.";
      } else {
        plan = "Primary Strategy: Endovascular Intervention First Choice.";
        ref = "Reference: GVG PLAN Algorithm - Endovascular options offer high technical success rates in low/moderate GLASS anatomic complexities.";
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
      appBar: AppBar(title: Text('Step 3: PLAN Strategy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Clinical Decision & Treatment Plan (Auto-Integrated)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  Text('WIfI from Step 1: ${SharedAppData.wifiText}', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                  SizedBox(height: 5),
                  Text('GLASS from Step 2: ${SharedAppData.glassText}', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                ],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: patientRisk,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(labelText: 'Patient Surgical Risk (ASA / Comorbidity)'),
              items: [
                DropdownMenuItem(value: "Average Risk", child: Text('Average Risk (Standard Surgical Candidate)')),
                DropdownMenuItem(value: "High Risk", child: Text('High Risk (High Anesthesia / Comorbidity Risk)')),
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
              child: Text('Generate PLAN Strategy & Evidence', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text('Recommended Treatment Plan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text(treatmentPlanResult, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFFFA000))),
                  SizedBox(height: 12),
                  Divider(color: Colors.grey.shade700),
                  SizedBox(height: 6),
                  Text('Guideline Rationale & References:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
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
