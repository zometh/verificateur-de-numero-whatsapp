import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Vérificateur de numéro whatsapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.black,
          secondary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(
        title: 'Vérificateur de numéro Whatsapp',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController controller;
  String indicatif = "";
  String numero = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 80, top: width / 5),
                  child: Image.asset(
                    "assets/loupe.png",
                    width: width / 2,
                    height: width / 2,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 30, right: 10, left: 10),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (newVal) {
                      setState(() {
                        numero = newVal;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "ex: 7X XXX XX XX",
                      label: const Text("Saisir le  numéro de téléphone "),
                    ),
                  ),
                ),
                Container(
                  height: 18,
                ),
                ElevatedButton(
                    onPressed: openWhatsapp,
                    style: ButtonStyle(
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade600)),
                    child: const Text(
                      "Vérifier",
                      style: TextStyle(fontSize: 25),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 80, bottom: 20),
                  child: const Text("zomethdev"),
                ),
                ElevatedButton(
                    onPressed: contact_me, child: const Text("Contactez-moi"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openWhatsapp() async {
    if (empty_number()) {
      emptyNumberSnackBar();
    } else {
      if (valid_number() == true) {
        if (await check_connectivity()) {
          String link = "https://wa.me/" + controller.text;
          final Uri url = Uri.parse(link);
          if (await launchUrl(url)) {
            //launchUrl(url);
            throw Exception();
          }
        } else {
          snack_bar();
        }
      } else {
        incorrectNumber();
      }
    }
  }

  Future<bool> check_connectivity() async {
    var isconnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isconnected = true;
      }
    } on SocketException catch (_) {
      isconnected = false;
    }
    return isconnected;
  }

  empty_number() {
    return controller.text == "";
  }

  snack_bar() {
    var snack = const SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Column(
          children: [
            Text(
              "Assurez-vous que votre appareil est bien connecté à internet puis réssayez!",
              textAlign: TextAlign.center,
            )
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  emptyNumberSnackBar() {
    var snack = const SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Column(
          children: [
            Text(
              "Veuillez d'abord saisir un numéro de téléphone!",
              textAlign: TextAlign.center,
            ),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  incorrectNumber() {
    var snack = const SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Column(
          children: [
            Text(
              "Numéro de téléphone incorrect",
              textAlign: TextAlign.center,
            ),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  bool valid_number() {
    /*List<String> valid_start = ["77", "78", "76", "70", "75"];
    var number_start = controller.text.substring(0, 2);
    bool valid = valid_start.contains(number_start);*/
    var str_interim = controller.text.replaceAll("+", "");
    var trim_string = str_interim.replaceAll(' ', '');
    return trim_string.length >= 9 && isNumeric(trim_string) == true;
  }

  bool isDark() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  Future<void> contact_me() async {
    String url = "mailto:metzodiop45@gmail.com";
    Uri url_uri = Uri.parse(url);
    if (await check_connectivity()) {
      if (await launchUrl(url_uri)) {
        //launchUrl(url);
        throw Exception();
      }
    } else {
      snack_bar();
    }
  }

  bool isNumeric(String str) {
    RegExp numeric = RegExp(r'^-?[0-9]+$');
    return numeric.hasMatch(str);
  }
}
