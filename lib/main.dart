import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_datastore_plugin_interface/src/types/models/subscription_event.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

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
  TestModel _testModel;
  String _lastEvent;
  StreamSubscription<SubscriptionEvent<TestModel>> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = Amplify.DataStore.observe(TestModel.classType)
        .listen(_onTestModelDataEvent);

    AmplifyDataStore.events.listenToDataStore((dynamic event) {
      final eventName = event['eventName'] as String;
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
          enumVal: TestEnum.VALUE_ONE,
          // intList: [1, 2, 3],
          // enumList: [TestEnum.VALUE_ONE, TestEnum.VALUE_TWO],
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
      final nextEnumVal = testModel.enumVal == TestEnum.VALUE_ONE
          ? TestEnum.VALUE_TWO
          : TestEnum.VALUE_ONE;
      // final nextEnumList = testModel.enumList.reversed.toList();
      // final nextNullableEnumList = testModel.nullableEnumList.reversed.toList();
      testModel = TestModel(
        id: testModel.id,
        testInt: testModel.testInt + 1,
        testString: 'string-${testModel.testInt + 1}',
        nullableInt:
            testModel.nullableInt == null ? testModel.testInt + 1 : null,
        // intList: testModel.intList.reversed.toList(),
        enumVal: nextEnumVal,
        nullableEnumVal: testModel.nullableEnumVal == null ? nextEnumVal : null,
        // enumList: nextEnumList,
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

  List<Widget> _testModelView() => <Widget>[
        Text('id: ${_testModel.id}'),
        Text('testInt: ${_testModel.testInt}'),
        Text('testString: ${_testModel.testString}'),
        Text('nullableInt: ${_testModel.nullableInt}'),
        // Text('intList: ${_testModel.intList}'),
        Text('enumVal: ${_testModel.enumVal}'),
        Text('nullableEnumVal: ${_testModel.nullableEnumVal}'),
        // Text('enumList: ${_testModel.enumList}'),
      ];
}
