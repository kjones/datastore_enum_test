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
  final String _testId = 'e2be8920-69b9-41ce-845f-321f3ac3455e';
  TestModel _testModel;

  void _incrementCounter() async {
    var testModel = _testModel;
    if (testModel == null) {
      final queryResult = await Amplify.DataStore.query(TestModel.classType,
          where: TestModel.ID.eq(_testId));
      if (queryResult.isEmpty) {
        testModel = TestModel(id: _testId, enumVal: TestEnum.VALUE_ONE);
        await Amplify.DataStore.save(testModel);
      } else {
        testModel = queryResult[0];
      }
    } else {
      final nextVal = testModel.enumVal == TestEnum.VALUE_ONE
          ? TestEnum.VALUE_TWO
          : TestEnum.VALUE_ONE;
      testModel = TestModel(id: _testId, enumVal: nextVal);
      await Amplify.DataStore.save(testModel);
    }
    setState(() {
      _testModel = testModel;
    });
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
            Text('TestModel:' + _testModel.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'update',
        child: Icon(Icons.add),
      ),
    );
  }
}
