import 'dart:async';

import 'package:amplify_datastore_plugin_interface/src/types/models/subscription_event.dart';
import 'package:flutter/material.dart';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final amplifyInstance = Amplify();
  var datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  await amplifyInstance.addPlugin(dataStorePlugins: [datastorePlugin]);
  await amplifyInstance.configure(amplifyconfig);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final String _testId = 'e2be8920-69b9-41ce-845f-321f3ac3455e';

  TestModel _testModel;
  String _lastEvent;
  StreamSubscription<SubscriptionEvent<TestModel>> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = Amplify.DataStore.observe(TestModel.classType)
        .listen(_onTestModelDataEvent);

    AmplifyDataStore.events.listenToDataStore((event) {
      final eventName = event['eventName'];
      setState(() {
        _lastEvent = eventName;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _onTestModelDataEvent(SubscriptionEvent<TestModel> event) {
    switch (event.eventType) {
      case EventType.create:
      case EventType.update:
        setState(() {
          _testModel = event.item;
        });
        break;
      case EventType.delete:
        setState(() {
          _testModel = null;
        });
        break;
    }
  }

  void _incrementTestModel() async {
    var testModel = _testModel;
    if (testModel == null) {
      final queryResult = await Amplify.DataStore.query(TestModel.classType);
      if (queryResult.isEmpty) {
        testModel = TestModel(
          id: null,
          testInt: 0,
          testString: 'testString-0',
        );
        await Amplify.DataStore.save(testModel);
      } else {
        testModel = queryResult[0];
        setState(() {
          _testModel = testModel;
        });
      }
    } else {
      testModel = TestModel(
        id: testModel.id,
        testInt: testModel.testInt + 1,
        testString: 'string-${testModel.testInt + 1}',
        nullableInt:
            (testModel.nullableInt == null) ? testModel.testInt + 1 : null,
      );
      await Amplify.DataStore.save(testModel);
    }
  }

  void _deleteTestModel() async {
    if (_testModel != null) {
      await Amplify.DataStore.delete(_testModel);
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('TestModel'),
            if (_testModel == null) Text('missing'),
            if (_testModel != null) Text('id: ${_testModel.id}'),
            if (_testModel != null) Text('testInt: ${_testModel.testInt}'),
            if (_testModel != null)
              Text('testString: ${_testModel.testString}'),
            if (_testModel != null)
              Text('nullableInt: ${_testModel.nullableInt}'),
            if (_lastEvent != null)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('lastEvent: $_lastEvent'),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _deleteTestModel,
            child: Icon(Icons.delete),
          ),
          FloatingActionButton(
            onPressed: _incrementTestModel,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
