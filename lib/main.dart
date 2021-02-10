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

  // Kickstart DataStore by submitting a query. Start/stop not available in Flutter.
  var _ = await Amplify.DataStore.query(TestModel.classType);

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

    Amplify.Hub.listen([HubChannel.DataStore], (dynamic event) async {
      final eventName = event.eventName as String;
      setState(() {
        _lastEvent = eventName;
      });

      if (eventName == 'ready') {
        _streamSubscription = Amplify.DataStore.observe(TestModel.classType)
            .listen(_onTestModelDataEvent);

        final queryResult = await Amplify.DataStore.query(TestModel.classType);
        if (queryResult.isNotEmpty) {
          final testModel = queryResult[0];
          setState(() {
            _testModel = testModel;
          });
        }
      }
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
          testFloat: 1.1,
          testString: 'string-0',
          testBool: true,
          testEnum: TestEnum.VALUE_ONE,
          intList: [1, 2, 3],
          floatList: [1.1, 2.2, 3.3],
          stringList: ['s0', 's1', 's3'],
          boolList: [true, false],
          enumList: [TestEnum.VALUE_ONE, TestEnum.VALUE_TWO],
          // nullableEnumList: [
          //   null,
          //   TestEnum.VALUE_ONE,
          //   null,
          //   TestEnum.VALUE_TWO
          // ],
        );
        await Amplify.DataStore.save(testModel);
      } else {
        testModel = queryResult[0];
        setState(() {
          _testModel = testModel;
        });
      }
    } else {
      final nextInt = testModel.testInt + 1;
      final nextFloat = nextInt + 0.1;
      final nextString = 'string-$nextInt';
      final nextBool = nextInt % 2 == 0;
      final nextEnumVal = testModel.testEnum == TestEnum.VALUE_ONE
          ? TestEnum.VALUE_TWO
          : TestEnum.VALUE_ONE;
      testModel = TestModel(
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
        intList: _tryReverseIntList(testModel.intList),
        floatList: testModel.floatList.reversed.toList(),
        stringList: testModel.stringList.reversed.toList(),
        boolList: testModel.boolList.reversed.toList(),
        enumList: testModel.enumList.reversed.toList(),
        // nullableEnumList: nextNullableEnumList,
        // enumNullableList:
        //     testModel.enumNullableList == null ? nextEnumList : null,
        // nullableEnumNullableList: testModel.nullableEnumNullableList == null
        //     ? nextNullableEnumList
        //     : null,
      );
      await Amplify.DataStore.save(testModel);
    }
  }

  static List<int> _tryReverseIntList(List<int> intList) {
    try {
      return intList.reversed.toList();
    } catch (ex) {
      // Set to something that indicates error during enumeration.
      return [99, 88, 77];
    }
  }

  void _deleteTestModel() async {
    if (_testModel != null) {
      await Amplify.DataStore.delete(_testModel);
    }
  }

  void _clearDataStore() async {
    await Amplify.DataStore.clear();
    setState(() {
      _testModel = null;
    });
    // Kickstart DataStore by submitting a query. Start/stop not available in Flutter.
    var _ = await Amplify.DataStore.query(TestModel.classType);
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: _incrementTestModel,
                label: Text('mutate'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _testModelView() {
    final intListStr = _tryGetIntListAsString(_testModel.intList);
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
      Text('intList: ${intListStr}'),
      Text('floatList: ${_testModel.floatList}'),
      Text('stringList: ${_testModel.stringList}'),
      Text('boolList: ${_testModel.boolList}'),
      Text('enumList: ${_testModel.enumList}'),
    ];
  }

  static String _tryGetIntListAsString(List<int> intList) {
    try {
      return '$intList';
    } catch (ex) {
      return '$ex';
    }
  }
}
