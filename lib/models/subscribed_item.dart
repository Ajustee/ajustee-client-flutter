import 'package:meta/meta.dart';

class SubscribedItem {
  String path;
  bool confirmed;
  Map<String, String> properties;
  SubscribedItem(
      {@required this.path, this.confirmed = false, this.properties});
}
