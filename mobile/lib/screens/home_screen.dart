import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  String _answer = 'ستظهر الإجابة هنا بعد إرسال السؤال.';
  bool _loading = false;

  Future<void> _createProject() async {
    final projectName = _projectNameController.text.trim();
    if (projectName.isEmpty) {
      _showSnack('يرجى إدخال اسم المشروع');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/projects'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': projectName}),
      );

      if (response.statusCode == 200) {
        _showSnack('تم إنشاء المشروع بنجاح');
      } else {
        _showSnack('حدث خطأ أثناء إنشاء المشروع');
      }
    } catch (e) {
      _showSnack('تعذر الاتصال بالخادم. تأكد من تشغيل الـ Backend');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _askQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      _showSnack('يرجى كتابة السؤال');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': 'demo-project',
          'question': question,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() => _answer = decoded['answer'] ?? 'لا يوجد جواب');
      } else {
        setState(() => _answer = 'حدث خطأ أثناء استدعاء AI');
      }
    } catch (e) {
      setState(() => _answer = 'تعذر الاتصال بالـ API. قم بتشغيل الـ Backend أولاً.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textDirection: TextDirection.rtl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zaker AI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'إنشاء مشروع جديد',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _projectNameController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'اسم المشروع',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loading ? null : _createProject,
                      child: const Text('إنشاء المشروع'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'اسأل عن الملف',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _questionController,
                        maxLines: 3,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          labelText: 'اكتب سؤالك هنا',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _loading ? null : _askQuestion,
                        child: const Text('إرسال السؤال'),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _answer,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
