import 'package:flutter/material.dart';
import 'package:ajustee_client/ajustee_client.dart';
import 'package:ajustee_client/models/configuration_key.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajustee client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyExamplePage(title: 'Example Page'),
    );
  }
}

class MyExamplePage extends StatefulWidget {
  MyExamplePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyExamplePageState createState() => _MyExamplePageState();
}

class _MyExamplePageState extends State<MyExamplePage> {
  AjusteeClient ajusteeClient;
  void _getConfiguration() async{
    List<ConfigurationKey> configKeys = await this.ajusteeClient.getConfigurations();

    configKeys.forEach((item) {
      print('${item.path} ${item.dataType} ${item.value}');
    });
  }

  void _saveConfiguration() async{
    this.ajusteeClient.saveConfigurations(path: 'myAwesomeFeature/IsEnabled', value: 'true');
  }

  void _subscribe() async{
    ajusteeClient.subscribe('myAwesomeFeature/IsEnabled', properties: {});

    ajusteeClient.onChanged().listen((List<ConfigurationKey> keys) {
      print("onChanged:");
      keys.forEach((item) {
        print('Path: ${item.path} Type: ${item.dataType} Value: ${item.value}');
      });
    });

    ajusteeClient.onKeyChanged().listen((ConfigurationKey key) {
        print('onKeyChanged: Path: ${key.path} Type: ${key.dataType} Value: ${key.value}');
    });

    ajusteeClient.onDeleted().listen((String path) {
      print("onDeleted $path");
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
  this.ajusteeClient = AjusteeClient(
      apiUrl: 'https://api.ajustee.com',
      socketUrl: 'wss://ws.ajustee.com',
      applicationId: 'diGBVHK4yus6A4bkg9O5AX~Xv.cvFdVw'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _getConfiguration,
              child: const Text('Get Configuration', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: _saveConfiguration,
              child: const Text('Save Configurations', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: _subscribe,
              child: const Text('Subscribe', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
   );
  }
}
