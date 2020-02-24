# Ajustee client example

Demonstrates how to use the Ajustee client.
In this example app, replace the string `YOUR_KEY` with your mobile key from your [Environments]

## Example

You just need to instantiate the class and initiate the client with your key, ajustee services urls. 
```dart
  AjusteeClient ajusteeClient = AjusteeClient(
    apiUrl: 'https://api.ajustee.com',
    socketUrl: 'wss://ws.ajustee.com',
    applicationId: 'YOUR_KEY'
  );
```

### Getting configurations

Get Configurations for all paths
```dart
  List<ConfigurationKey> configKeys = await this.ajusteeClient.getConfigurations();

  configKeys.forEach((item) {
    print('${item.path} ${item.dataType} ${item.value}');
  });
```

Get Configurations for by path (path is optional)
```dart
  List<ConfigurationKey> configKeys = await this.ajusteeClient.getConfigurations(path: 'myAwesomeFeature/IsEnabled');

  configKeys.forEach((item) {
    print('${item.path} ${item.dataType} ${item.value}');
  });
```

Passing properties inside getConfigurations method (properties is optional)
```dart
  List<ConfigurationKey> configKeys = await this.ajusteeClient.getConfigurations(properties: {'name': 'value'});

  configKeys.forEach((item) {
    print('${item.path} ${item.dataType} ${item.value}');
  });
```

Save configurations by path
```dart

  ajusteeClient.saveConfigurations(path: 'myAwesomeFeature/IsEnabled', value: 'true');
```

Watching for configuration changes and deleted
```dart
  // To subscribe for changes call 
  ajusteeClient.subscribe('myAwesomeFeature/IsEnabled');
  ajusteeClient.subscribe('myAwesomeFeature/Timeout');
  
  // Subscribe for all configuration paths changes event
  ajusteeClient.onChanged().listen((List<ConfigurationKey> keys) {
    print("onChanged:");
    keys.forEach((item) {
      print('Path: ${item.path} Type: ${item.dataType} Value: ${item.value}');
    });
  });
  
  // Subscribe for changes for single configuration path event
  ajusteeClient.onKeyChanged().listen((ConfigurationKey key) {
    print('onKeyChanged: Path: ${key.path} Type: ${key.dataType} Value: ${key.value}');
  });
  
  // Subscribe for deleted configuration path event
  ajusteeClient.onDeleted().listen((String path) {
    print("onDeleted $path");
  });
```