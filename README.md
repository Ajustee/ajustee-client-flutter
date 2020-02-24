# ajustee_client

Ajustee flutter client


## Public Method Summary
In this table you can find the different functions exposed by this plugin:
    
| Return |Description|
|--------|-----|
| AjusteeClient |  **AjusteeClient(String apiUrl, String applicationId, String socketUrl, String trackerId: null, Map<String, String> defaultProperties: {}, String defaultPath: null, bool reconnect: true, int reconnectTimeout = 5000 )** <br>Request configuration params list. Return a list with ConfigurationKeys. |
| async void |  **subscribe(String path: null, Map<String, String> properties: {})** <br>Subscribe for changes of configuration key by path. |
| async void |  **unsubscribe(String path: null)** <br>Unsubscribe for changes of configuration key by path. |
| async Future<List<ConfigurationKey>> |  **getConfigurations(String path: null, Map<String, String> properties: {})** <br>Request configuration params list. Return a list with ConfigurationKeys. |
| Stream\<List<ConfigurationKey>> | **onChanged()** <br>Get the stream of the configurations changes. |
| Stream\<ConfigurationKey> | **onKeyChanged()** <br>Get the stream of the single configurations key changes. |
| Stream\<String> | **onDeleted()** <br>Get the stream of the configurations changes. |
