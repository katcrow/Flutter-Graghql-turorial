import 'package:flutter/foundation.dart';
import 'package:graphql_app/Schemas/add_task_schema.dart';
import 'package:graphql_app/Schemas/urlEndpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddTaskProvider extends ChangeNotifier {
  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  final EndPoint _point = EndPoint();

  ///Add task method
  void addTask({String? task, String? status}) async {
    _status = true;
    _response = "Please wait...";
    notifyListeners();

    ValueNotifier<GraphQLClient> _client = _point.getClient();

    QueryResult result = await _client.value.mutate(
        MutationOptions(document: gql(AddTaskSchema.addTaskJson), variables: {
      'task': task,
      'status': status,
    }));

    if (result.hasException) {
      print(result.exception);
      _status = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = "Internet is not found";
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      print(result.data);
      _status = false;
      _response = "Task was successfully added";
      notifyListeners();
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
