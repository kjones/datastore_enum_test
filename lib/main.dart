import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_datastore_plugin_interface/src/types/models/subscription_event.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var apiPlugin = AmplifyAPI();
  var datastorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  await Amplify.addPlugins([apiPlugin, datastorePlugin]);
  await Amplify.configure(amplifyconfig);

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
  TestModel _testModel;
  String _lastEvent;
  StreamSubscription<SubscriptionEvent<TestModel>> _streamSubscription;

  @override
  void initState() {
    super.initState();

    _listenForDataStoreHubEvents();

    // Kickstart DataStore by submitting a query. Start/stop not available in Flutter.
    Amplify.DataStore.query(TestModel.classType);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;

    super.dispose();
  }

  void _listenForDataStoreHubEvents() {
    Amplify.Hub.listen([HubChannel.DataStore], _handleDataStoreHubEvent);
  }

  Future<void> _handleDataStoreHubEvent(dynamic event) async {
    final eventName = event.eventName as String;
    setState(() {
      _lastEvent = eventName;
    });

    if (eventName != 'ready') {
      return;
    }

    if (_streamSubscription != null) {
      throw Exception('Oh no!');
    }

    print('Establishing TestModel subscription');
    _streamSubscription = Amplify.DataStore.observe(TestModel.classType)
        .listen(_onTestModelDataEvent);

    final queryResult = await Amplify.DataStore.query(TestModel.classType);
    if (queryResult.isNotEmpty) {
      setState(() {
        _testModel = queryResult[0];
      });
    }
  }

  void _onTestModelDataEvent(SubscriptionEvent<TestModel> event) {
    print('${event.eventType} - ${event.modelType}');
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

  Future<void> _updateTestModel() async {
    if (_testModel == null) {
      final queryResult = await Amplify.DataStore.query(TestModel.classType);
      if (queryResult.isNotEmpty) {
        setState(() {
          _testModel = queryResult[0];
        });
      } else {
        final testModel = await _createInitialTestModel();
        await Amplify.DataStore.save(testModel);
      }
    } else {
      final testModel = _generateNextTestModel(_testModel);
      await Amplify.DataStore.save(testModel);
    }
  }

  static TestModel _createInitialTestModel() => TestModel(
        id: null,
        testInt: 1,
        testFloat: 1,
        testString: 'string-0',
        testBool: true,
        testEnum: TestEnum.VALUE_ONE,
        intList: [1, 2, 3],
        floatList: [1.1, 2.2, 3.3],
        stringList: ['s0', 's1', 's3'],
        boolList: [true, false],
        enumList: [TestEnum.VALUE_ONE, TestEnum.VALUE_TWO],
      );

  static TestModel _generateNextTestModel(TestModel testModel) {
    final nextInt = testModel.testInt + 1;
    final nextFloat = nextInt.toDouble();
    final nextString = 'string-$nextInt';
    final nextBool = nextInt % 2 == 0;
    final nextEnumVal = testModel.testEnum == TestEnum.VALUE_ONE
        ? TestEnum.VALUE_TWO
        : TestEnum.VALUE_ONE;

    final nextIntList = testModel.intList.reversed.toList();
    final nextFloatList = testModel.floatList.reversed.toList();
    final nextStringList = testModel.stringList.reversed.toList();
    final nextBoolList = testModel.boolList.reversed.toList();
    final nextEnumList = testModel.enumList.reversed.toList();

    return TestModel(
      id: testModel.id,
      testInt: nextInt,
      testFloat: nextFloat,
      testString: nextString,
      testBool: nextBool,
      testEnum: nextEnumVal,
      nullableInt: testModel.nullableInt == null ? nextInt : null,
      nullableFloat: testModel.nullableFloat == null ? nextFloat : null,
      nullableString: testModel.nullableString == null ? nextString : null,
      nullableBool: testModel.nullableBool == null ? nextBool : null,
      nullableEnum: testModel.nullableEnum == null ? nextEnumVal : null,
      intList: nextIntList,
      floatList: nextFloatList,
      stringList: nextStringList,
      boolList: nextBoolList,
      enumList: nextEnumList,
      intNullableList: testModel.intNullableList == null ? nextIntList : null,
      floatNullableList:
          testModel.floatNullableList == null ? nextFloatList : null,
      stringNullableList:
          testModel.stringNullableList == null ? nextStringList : null,
      boolNullableList:
          testModel.boolNullableList == null ? nextBoolList : null,
      enumNullableList:
          testModel.enumNullableList == null ? nextEnumList : null,
    );
  }

  void _deleteTestModel() async {
    if (_testModel != null) {
      await Amplify.DataStore.delete(_testModel);
    }
  }

  void _clearDataStore() async {
    print('Cancelling TestModel subscription');
    await _streamSubscription.cancel();
    _streamSubscription = null;

    setState(() {
      _testModel = null;
    });

    await Amplify.DataStore.clear();

    // Kickstart DataStore by submitting a query. Start/stop not available in Flutter.
    await Amplify.DataStore.query(TestModel.classType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('TestModel'),
            if (_testModel == null) Text('missing'),
            if (_testModel != null) ..._testModelView(),
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
          Container(
            height: 40.0,
            width: 100.0,
            child: SizedBox(
              child: FloatingActionButton.extended(
                  onPressed: _clearDataStore, label: Text('clear DS')),
            ),
          ),
          Container(
            height: 40.0,
            width: 100.0,
            child: SizedBox(
              child: FloatingActionButton.extended(
                  onPressed: _deleteTestModel, label: Text('delete')),
            ),
          ),
          Container(
            height: 40.0,
            width: 100.0,
            child: SizedBox(
              child: FloatingActionButton.extended(
                onPressed: _updateTestModel,
                label: Text('mutate'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _testModelView() {
    return <Widget>[
      Text('id: ${_testModel.id}'),
      Text('testInt: ${_testModel.testInt}'),
      Text('testFloat: ${_testModel.testFloat}'),
      Text('testString: ${_testModel.testString}'),
      Text('testBool: ${_testModel.testBool}'),
      Text('testEnum: ${_testModel.testEnum}'),
      Text('nullableInt: ${_testModel.nullableInt}'),
      Text('nullableFloat: ${_testModel.nullableFloat}'),
      Text('nullableString: ${_testModel.nullableString}'),
      Text('nullableBool: ${_testModel.nullableBool}'),
      Text('nullableEnum: ${_testModel.nullableEnum}'),
      Text('intList: ${_testModel.intList}'),
      Text('floatList: ${_testModel.floatList}'),
      Text('stringList: ${_testModel.stringList}'),
      Text('boolList: ${_testModel.boolList}'),
      Text('enumList: ${_testModel.enumList}'),
      Text('intNullableList: ${_testModel.intNullableList}'),
      Text('floatNullableList: ${_testModel.floatNullableList}'),
      Text('stringNullableList: ${_testModel.stringNullableList}'),
      Text('boolNullableList: ${_testModel.boolNullableList}'),
      Text('enumNullableList: ${_testModel.enumNullableList}'),
    ];
  }
}
