import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'go': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'dont': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'do': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  get controller1 => null;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = TextEditingController();
    _copy() {
      final value = ClipboardData(text: controller1.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Accuracy : ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        actions: [
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(_text);
            },
            icon: Icon(Icons.content_copy),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new MyHomePage()),
              );
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: 676,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://img.freepik.com/free-vector/purple-fluid-background_53876-99561.jpg?w=360&t=st=1676967811~exp=1676968411~hmac=90b7b685e5ec007bce6207c7becd7fd12ce761eb87d4e605d2b86b827288ea6b"),
                fit: BoxFit.cover),
          ),
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  GoogleTranslator translator = GoogleTranslator();
  var output;
  String dropdownValue;

  static const Map<String, String> lang = {
    "Hindi": "hi",
    "Urdu": "ur",  
"Abkhazian":	"ab",	
"Avestan"	:"ae",	
"Afrikaans"	:"af",	
"Akan	ak"	:"aka",	
"Amharic"	:"am",	
"Aragonese":	"an",	
"Arabic":	"ar",	
"Assamese":	"as",	
"Avaric":	"av",	
"Aymara"	:"ay",	
"Azerbaijani"	:"az",	
"Bashkir"	:"ba",	
"Belarusian"	:"be",	
"Bulgarian"	:"bg",							
"Bislama"	:"bi",
"Bambara"	:"bm",	
"Bengali"	:"bn",	
"Tibetan"	:"bo",
"Breton"	:"br",	
"Bosnian"	:"bs",	
"Chechen"	:"ce",	
"Chamorro"	:"ch",	
"Corsican"	:"co",	
"Cree	cr"	:"cre",	
"Czech	cs"	:"cze",
"Welsh	cy"	:"wel",	
"Danish"	:"da",	
"German"	:"de",	
"Dzongkha"	:"dz",	
"English"	:"en",	
"Esperanto"	:"eo",	
"Spanish"	:"es",	
"Estonian"	:"et",	
"Basque"	:"eu",	
"Persian"	:"fa",
  };

  void trans() {
    translator
        .translate(textEditingController.text, to: "$dropdownValue")
        .then((value) {
      setState(() {
        output = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
                  actions: [
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(output.toString());
            },
            icon: Icon(Icons.content_copy),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new SecondPage()),
              );
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
          title: Text("Multi Language Translator"),
        ),
        body: Container(
                    height: 676,
          width: double.infinity,
                                  decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://img.freepik.com/free-vector/purple-fluid-background_53876-99561.jpg?w=360&t=st=1676967811~exp=1676968411~hmac=90b7b685e5ec007bce6207c7becd7fd12ce761eb87d4e605d2b86b827288ea6b"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: TextStyle(fontSize: 24),
                  controller: textEditingController,
                  onTap: () {
                    trans();
                  },
                  decoration: InputDecoration(
                      labelText: 'Type Here',
                      labelStyle: TextStyle(fontSize: 15)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Select Language here =>"),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        trans();
                      });
                    },
                    items: lang
                        .map((string, value) {
                          return MapEntry(
                            string,
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(string),
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text('Translated Text'),
              SizedBox(
                height: 10,
              ),
              Text(
                output == null ? "Please Select Language" : output.toString(),
                style: TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}

class SecondPage extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text To Speech'),
      ),
      body: Center(
        child: Container(
                              height: 676,
          width: double.infinity,
                                  decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://img.freepik.com/free-vector/purple-fluid-background_53876-99561.jpg?w=360&t=st=1676967811~exp=1676968411~hmac=90b7b685e5ec007bce6207c7becd7fd12ce761eb87d4e605d2b86b827288ea6b"),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: TextFormField(
                  controller: textEditingController,
                ),
              ),
              GestureDetector(
                onTap: () {
                  textToSpeech(textEditingController.text);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Slider(
                  value: volume,
                  onChanged: (value) {
                  })
            ],
          ),
        ),
      ),
    );
  }
}
