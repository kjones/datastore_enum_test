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

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the TestModel type in your schema. */
@immutable
class TestModel extends Model {
  static const classType = const TestModelType();
  final String id;
  final TestEnum enumVal;
  final TestEnum nullableEnumVal;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const TestModel._internal(
      {@required this.id, @required this.enumVal, this.nullableEnumVal});

  factory TestModel(
      {@required String id,
      @required TestEnum enumVal,
      TestEnum nullableEnumVal}) {
    return TestModel._internal(
        id: id == null ? UUID.getUUID() : id,
        enumVal: enumVal,
        nullableEnumVal: nullableEnumVal);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TestModel &&
        id == other.id &&
        enumVal == other.enumVal &&
        nullableEnumVal == other.nullableEnumVal;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("TestModel {");
    buffer.write("id=" + id + ", ");
    buffer.write("enumVal=" + enumToString(enumVal) + ", ");
    buffer.write("nullableEnumVal=" + enumToString(nullableEnumVal));
    buffer.write("}");

    return buffer.toString();
  }

  TestModel copyWith(
      {@required String id,
      @required TestEnum enumVal,
      TestEnum nullableEnumVal}) {
    return TestModel(
        id: id ?? this.id,
        enumVal: enumVal ?? this.enumVal,
        nullableEnumVal: nullableEnumVal ?? this.nullableEnumVal);
  }

  TestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        enumVal = enumFromString<TestEnum>(json['enumVal'], TestEnum.values),
        nullableEnumVal =
            enumFromString<TestEnum>(json['nullableEnumVal'], TestEnum.values);

  Map<String, dynamic> toJson() => {
        'id': id,
        'enumVal': enumToString(enumVal),
        'nullableEnumVal': enumToString(nullableEnumVal)
      };

  static final QueryField ID = QueryField(fieldName: "testModel.id");
  static final QueryField ENUMVAL = QueryField(fieldName: "enumVal");
  static final QueryField NULLABLEENUMVAL =
      QueryField(fieldName: "nullableEnumVal");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TestModel";
    modelSchemaDefinition.pluralName = "TestModels";

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.ENUMVAL,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: TestModel.NULLABLEENUMVAL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));
  });
}

class TestModelType extends ModelType<TestModel> {
  const TestModelType();

  @override
  TestModel fromJson(Map<String, dynamic> jsonData) {
    return TestModel.fromJson(jsonData);
  }
}
