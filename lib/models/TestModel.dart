/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the TestModel type in your schema. */
@immutable
class TestModel extends Model {
  static const classType = const TestModelType();
  final String id;
  final int testInt;
  final double testFloat;
  final String testString;
  final bool testBool;
  final TestEnum testEnum;
  final int nullableInt;
  final double nullableFloat;
  final String nullableString;
  final bool nullableBool;
  final TestEnum nullableEnum;
  final List<int> intList;
  final List<double> floatList;
  final List<String> stringList;
  final List<bool> boolList;
  final List<TestEnum> enumList;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const TestModel._internal(
      {@required this.id,
      @required this.testInt,
      @required this.testFloat,
      @required this.testString,
      @required this.testBool,
      @required this.testEnum,
      this.nullableInt,
      this.nullableFloat,
      this.nullableString,
      this.nullableBool,
      this.nullableEnum,
      this.intList,
      this.floatList,
      this.stringList,
      this.boolList,
      this.enumList});

  factory TestModel(
      {String id,
      @required int testInt,
      @required double testFloat,
      @required String testString,
      @required bool testBool,
      @required TestEnum testEnum,
      int nullableInt,
      double nullableFloat,
      String nullableString,
      bool nullableBool,
      TestEnum nullableEnum,
      List<int> intList,
      List<double> floatList,
      List<String> stringList,
      List<bool> boolList,
      List<TestEnum> enumList}) {
    return TestModel._internal(
        id: id == null ? UUID.getUUID() : id,
        testInt: testInt,
        testFloat: testFloat,
        testString: testString,
        testBool: testBool,
        testEnum: testEnum,
        nullableInt: nullableInt,
        nullableFloat: nullableFloat,
        nullableString: nullableString,
        nullableBool: nullableBool,
        nullableEnum: nullableEnum,
        intList: intList != null ? List.unmodifiable(intList) : intList,
        floatList: floatList != null ? List.unmodifiable(floatList) : floatList,
        stringList:
            stringList != null ? List.unmodifiable(stringList) : stringList,
        boolList: boolList != null ? List.unmodifiable(boolList) : boolList,
        enumList: enumList != null ? List.unmodifiable(enumList) : enumList);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TestModel &&
        id == other.id &&
        testInt == other.testInt &&
        testFloat == other.testFloat &&
        testString == other.testString &&
        testBool == other.testBool &&
        testEnum == other.testEnum &&
        nullableInt == other.nullableInt &&
        nullableFloat == other.nullableFloat &&
        nullableString == other.nullableString &&
        nullableBool == other.nullableBool &&
        nullableEnum == other.nullableEnum &&
        DeepCollectionEquality().equals(intList, other.intList) &&
        DeepCollectionEquality().equals(floatList, other.floatList) &&
        DeepCollectionEquality().equals(stringList, other.stringList) &&
        DeepCollectionEquality().equals(boolList, other.boolList) &&
        DeepCollectionEquality().equals(enumList, other.enumList);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("TestModel {");
    buffer.write("id=" + id + ", ");
    buffer.write(
        "testInt=" + (testInt != null ? testInt.toString() : "null") + ", ");
    buffer.write("testFloat=" +
        (testFloat != null ? testFloat.toString() : "null") +
        ", ");
    buffer.write("testString=" + testString + ", ");
    buffer.write(
        "testBool=" + (testBool != null ? testBool.toString() : "null") + ", ");
    buffer.write("testEnum=" + enumToString(testEnum) + ", ");
    buffer.write("nullableInt=" +
        (nullableInt != null ? nullableInt.toString() : "null") +
        ", ");
    buffer.write("nullableFloat=" +
        (nullableFloat != null ? nullableFloat.toString() : "null") +
        ", ");
    buffer.write("nullableString=" + nullableString + ", ");
    buffer.write("nullableBool=" +
        (nullableBool != null ? nullableBool.toString() : "null") +
        ", ");
    buffer.write("nullableEnum=" + enumToString(nullableEnum) + ", ");
    buffer.write(
        "intList=" + (intList != null ? intList.toString() : "null") + ", ");
    buffer.write("floatList=" +
        (floatList != null ? floatList.toString() : "null") +
        ", ");
    buffer.write("stringList=" +
        (stringList != null ? stringList.toString() : "null") +
        ", ");
    buffer.write(
        "boolList=" + (boolList != null ? boolList.toString() : "null") + ", ");
    buffer
        .write("enumList=" + enumList?.map((e) => enumToString(e)).toString());
    buffer.write("}");

    return buffer.toString();
  }

  TestModel copyWith(
      {String id,
      int testInt,
      double testFloat,
      String testString,
      bool testBool,
      TestEnum testEnum,
      int nullableInt,
      double nullableFloat,
      String nullableString,
      bool nullableBool,
      TestEnum nullableEnum,
      List<int> intList,
      List<double> floatList,
      List<String> stringList,
      List<bool> boolList,
      List<TestEnum> enumList}) {
    return TestModel(
        id: id ?? this.id,
        testInt: testInt ?? this.testInt,
        testFloat: testFloat ?? this.testFloat,
        testString: testString ?? this.testString,
        testBool: testBool ?? this.testBool,
        testEnum: testEnum ?? this.testEnum,
        nullableInt: nullableInt ?? this.nullableInt,
        nullableFloat: nullableFloat ?? this.nullableFloat,
        nullableString: nullableString ?? this.nullableString,
        nullableBool: nullableBool ?? this.nullableBool,
        nullableEnum: nullableEnum ?? this.nullableEnum,
        intList: intList ?? this.intList,
        floatList: floatList ?? this.floatList,
        stringList: stringList ?? this.stringList,
        boolList: boolList ?? this.boolList,
        enumList: enumList ?? this.enumList);
  }

  TestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        testInt = json['testInt'],
        testFloat = json['testFloat'],
        testString = json['testString'],
        testBool = json['testBool'],
        testEnum = enumFromString<TestEnum>(json['testEnum'], TestEnum.values),
        nullableInt = json['nullableInt'],
        nullableFloat = json['nullableFloat'],
        nullableString = json['nullableString'],
        nullableBool = json['nullableBool'],
        nullableEnum =
            enumFromString<TestEnum>(json['nullableEnum'], TestEnum.values),
        intList = (json['intList'] as List<dynamic>)
            .map((dynamic e) => e is double ? e.toInt() : e as int)
            .toList(),
        floatList = json['floatList']?.cast<double>(),
        stringList = json['stringList']?.cast<String>(),
        boolList = json['boolList']?.cast<bool>(),
        enumList = json['enumList'] is List
            ? (json['enumList'] as List)
                .map((e) => enumFromString<TestEnum>(e, TestEnum.values))
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'testInt': testInt,
        'testFloat': testFloat,
        'testString': testString,
        'testBool': testBool,
        'testEnum': enumToString(testEnum),
        'nullableInt': nullableInt,
        'nullableFloat': nullableFloat,
        'nullableString': nullableString,
        'nullableBool': nullableBool,
        'nullableEnum': enumToString(nullableEnum),
        'intList': intList,
        'floatList': floatList,
        'stringList': stringList,
        'boolList': boolList,
        'enumList': enumList?.map((e) => enumToString(e))?.toList()
      };

  static final QueryField ID = QueryField(fieldName: "testModel.id");
  static final QueryField TESTINT = QueryField(fieldName: "testInt");
  static final QueryField TESTFLOAT = QueryField(fieldName: "testFloat");
  static final QueryField TESTSTRING = QueryField(fieldName: "testString");
  static final QueryField TESTBOOL = QueryField(fieldName: "testBool");
  static final QueryField TESTENUM = QueryField(fieldName: "testEnum");
  static final QueryField NULLABLEINT = QueryField(fieldName: "nullableInt");
  static final QueryField NULLABLEFLOAT =
      QueryField(fieldName: "nullableFloat");
  static final QueryField NULLABLESTRING =
      QueryField(fieldName: "nullableString");
  static final QueryField NULLABLEBOOL = QueryField(fieldName: "nullableBool");
  static final QueryField NULLABLEENUM = QueryField(fieldName: "nullableEnum");
  static final QueryField INTLIST = QueryField(fieldName: "intList");
  static final QueryField FLOATLIST = QueryField(fieldName: "floatList");
  static final QueryField STRINGLIST = QueryField(fieldName: "stringList");
  static final QueryField BOOLLIST = QueryField(fieldName: "boolList");
  static final QueryField ENUMLIST = QueryField(fieldName: "enumList");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TestModel";
    modelSchemaDefinition.pluralName = "TestModels";

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.TESTINT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.TESTFLOAT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.TESTSTRING,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.TESTBOOL,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.TESTENUM,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLEINT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLEFLOAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLESTRING,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLEBOOL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLEENUM,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.INTLIST,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.int))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.FLOATLIST,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.double))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.STRINGLIST,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.BOOLLIST,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.bool))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.ENUMLIST,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.enumeration))));
  });
}

class TestModelType extends ModelType<TestModel> {
  const TestModelType();

  @override
  TestModel fromJson(Map<String, dynamic> jsonData) {
    return TestModel.fromJson(jsonData);
  }
}
