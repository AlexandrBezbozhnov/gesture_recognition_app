import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MaterialApp(
    home: GestureRecognitionApp(),
  ));
}

class GestureRecognitionApp extends StatefulWidget {
  @override
  _GestureRecognitionAppState createState() => _GestureRecognitionAppState();
}

class _GestureRecognitionAppState extends State<GestureRecognitionApp> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  String _selectedLanguage = 'English'; // Язык по умолчанию
  String _selectedTargetLanguage = 'Spanish'; // Другой язык по умолчанию
  bool _isRecording = false; // Флаг для записи перевода
  int _selectedCamera = 0; // Индекс выбранной камеры

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _showInitialLanguageNotification(); // Показ уведомления
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[_selectedCamera],
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _showInitialLanguageNotification() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Исходный язык для перевода:'),
            content: Text('$_selectedLanguage'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ОК'),
              ),
            ],
          );
        },
      );
    });
  }

  void _translate() {
    // Здесь можно добавить код для выполнения перевода
  }

  void _startRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // Если запись активна, поменять текст на кнопке
    } else {
      // Если запись остановлена, открыть новую страницу
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TranslationResultPage(),
        ),
      );
    }
  }

  void _switchCamera() {
    setState(() {
      _selectedCamera = (_selectedCamera + 1) % _cameras.length;
      _cameraController = CameraController(
        _cameras[_selectedCamera],
        ResolutionPreset.medium,
      );
      _cameraController!.initialize().then((_) {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String selectedLanguage) {
    setState(() {
      _selectedLanguage = selectedLanguage;
    });
    // Здесь можно добавить код для обновления перевода на выбранный язык
  }

  void _onTargetLanguageChanged(String selectedTargetLanguage) {
    setState(() {
      _selectedTargetLanguage = selectedTargetLanguage;
    });
    // Здесь можно добавить код для обновления целевого перевода на выбранный язык
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Recognition'),
      ),
      body: Column(
        children: [
          CameraPreview(_cameraController!),
          // Добавление первого виджета для выбора языка
          ListTile(
            title: Text('Выберите жестовый язык:'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _onLanguageChanged(newValue);
                }
              },
              items: <String>['English', 'Spanish', 'French', 'German'] // Здесь можно добавить другие языки
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Добавление второго виджета для выбора языка
          ListTile(
            title: Text('Выберите целевой язык:'),
            trailing: DropdownButton<String>(
              value: _selectedTargetLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _onTargetLanguageChanged(newValue);
                }
              },
              items: <String>['English', 'Spanish', 'French', 'German'] // Здесь можно добавить другие языки
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Добавление кнопки "Перевести"
          // Добавление кнопки "Запись перевода"
          // Добавление кнопки "Сменить камеру"
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startRecording,
                  child: Text(_isRecording ? 'Остановить запись' : 'Запись перевода'),
                ),
                ElevatedButton(
                  onPressed: _switchCamera,
                  child: Text('Сменить камеру'),
                ),
              ],
            ),
          ),
          // Здесь добавьте другие элементы интерфейса для отображения результатов и управления приложением
        ],
      ),
    );
  }
}



class TranslationResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation Result'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Пример, текст.Это, жесты, текст, составлен, из',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Пример текста. Этот текст составлен из жестов.',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Обработка нажатия для голосового перевода
                  },
                  child: Text('Голосовой перевод'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть страницу'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
