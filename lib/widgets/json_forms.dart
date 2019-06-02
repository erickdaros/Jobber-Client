import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'cform/textfield.dart';

//TextField
//  String form = json.encode([
//    {
//      'type': 'Input',
//      'title': 'Hi Group',
//      'placeholder': "Hi Group flutter"
//    },
//    {
//      'type': 'Password',
//      'title': 'Password',
//    },
//    {
//      'type': 'Email',
//      'title': 'Email test',
//      'placeholder': "hola a todos"
//    },
//    {
//      'type': 'TareaText',
//      'title': 'TareaText test',
//      'placeholder': "hola a todos"
//    },
//  ]);
//Radio
// String form = json.encode([
//    {
//      'type': 'RadioButton',
//      'title': 'Radio Button tests',
//      'value': 2,
//      'list': [
//        {
//          'title': "product 1",
//          'value': 1,
//        },
//        {
//          'title': "product 2",
//          'value': 2,
//        },
//        {
//          'title': "product 3",
//          'value': 3,
//        }
//      ]
//    },
//  ]);
//Switch
//String form = json.encode([
//    {
//      'type': 'Switch',
//      'title': 'Switch test',
//      'switchValue': false,
//    },
//  ]);
//Checkbox
//String form = json.encode([
//    {
//      'type': 'Checkbox',
//      'title': 'Checkbox test 2',
//      'list': [
//        {
//          'title': "product 1",
//          'value': true,
//        },
//        {
//          'title': "product 2",
//          'value': true,
//        },
//        {
//          'title': "product 3",
//          'value': false,
//        }
//      ]
//    },
//  ]);
//

class CForm extends StatefulWidget {
  const CForm({
    @required this.form,
    @required this.onChanged,
    @required this.formKey,
    this.padding,
    this.formMap,
  });

  final String form;
  final dynamic formMap;
  final double padding;
  final formKey;
  final ValueChanged<dynamic> onChanged;

  @override
  _CFormState createState() =>
      new _CFormState(formMap ?? json.decode(form));
}

class _CFormState extends State<CForm> {

  final dynamic formItems;

  int radioValue;

  _CFormState(this.formItems);

  List<Widget> jsonToForm() {
    List<Widget> listWidget = new List<Widget>();

    for (var count = 0; count < formItems.length; count++) {
      Map item = formItems[count];

      print(item);
      if (item['type'] == "Input" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TextArea"||
          item['type'] == "Date") {

        CFTextFieldType type;

        switch(item['type']){
          case 'Input':
            type = CFTextFieldType.input;
            break;
          case 'Password':
            type = CFTextFieldType.password;
            break;
          case 'Email':
            type = CFTextFieldType.email;
            break;
          case 'TextArea':
            type = CFTextFieldType.textArea;
            break;
          case 'Date':
            type = CFTextFieldType.date;
            break;
          default:
            type = CFTextFieldType.input;
            break;
        }

        if(item['required'] != null){
          print(item['required']['if']);
          print(formItems[item['required']['if']]);
          if(formItems[item['required']['if']]['value'] == item['required']['equal']){
            listWidget.add(
                new CFTextField(
                  title: item['title'],
                  type: type,
                  extraPadding: item['style']['helperText']!=null||item['style']['maxLength']!=null,
                  labelText: item['style']['placeholder'] ?? "",
                  maxLines: item['type'] == "TextArea" ? 10 : 1,
                  helperText: item['style']['helperText'] ?? "",
                  helperTextColor: item['style']['helperTextColor'] ?? "#000000",
                  validate: item['style']['validate'] ?? false,
                  prefixIcon: item['style']['prefixIcon'] ?? null,
                  validatorText: item['style']['validatorText'] ?? "",
                  maxLength: type==CFTextFieldType.date?10:item['style']['maxLength'] ?? null,
                  onSaved: (String value) {
                    formItems[count]['response'] = value;
                    _handleChanged();
                  },
                )
            );
          }
        }else {
          listWidget.add(
              new CFTextField(
                title: item['title'],
                type: type,
                extraPadding: item['style']['helperText']!=null||item['style']['maxLength']!=null,
                labelText: item['style']['placeholder'] ?? "",
                maxLines: item['type'] == "TextArea" ? 10 : 1,
                helperText: item['style']['helperText'] ?? "",
                helperTextColor: item['style']['helperTextColor'] ?? "#000000",
                validate: item['style']['validate'] ?? false,
                prefixIcon: item['style']['prefixIcon'] ?? null,
                validatorText: item['style']['validatorText'] ?? "",
                maxLength: type==CFTextFieldType.date?10:item['style']['maxLength'] ?? null,
                onSaved: (String value) {
                  formItems[count]['response'] = value;
                  _handleChanged();
                },
              )
          );
        }
      }

      if (item['type'] == "RadioButton") {
        listWidget.add(new Container(
            margin: new EdgeInsets.all(5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        radioValue = item['value'];
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(new Row(children: <Widget>[
            new Expanded(
                child: new Text(formItems[count]['list'][i]['title'])),
            new Radio<int>(
                value: formItems[count]['list'][i]['value'],
                groupValue: radioValue,
                onChanged: (int value) {
                  this.setState(() {
                    radioValue = value;
                    formItems[count]['value'] = value;
                    _handleChanged();
                  });
                })
          ]));
        }
      }

      if (item['type'] == "Switch") {
        listWidget.add(
          new Row(children: <Widget>[
            new Expanded(child: new Text(item['title'])),
            new Switch(
                value: item['switchValue'],
                onChanged: (bool value) {
                  this.setState(() {
                    formItems[count]['switchValue'] = value;
                    _handleChanged();
                  });
                })
          ]),
        );
      }

      if (item['type'] == "Checkbox") {
        listWidget.add(new Container(
            margin: new EdgeInsets.all(5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(new Row(children: <Widget>[
            new Expanded(
                child: new Text(formItems[count]['list'][i]['title'])),
            new Checkbox(
                value: formItems[count]['list'][i]['value'],
                onChanged: (bool value) {
                  this.setState(() {
                    formItems[count]['list'][i]['value'] = value;
                    _handleChanged();
                  });
                })
          ]));
        }
      }
    }
    return listWidget;
  }

  void _handleChanged() {
    widget.onChanged(formItems);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: jsonToForm(),
      ),
    );
//    return new Container(
//      padding: new EdgeInsets.all(widget.padding ?? 8.0),
//      child: new Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: JsonToForm(),
//      ),
//    );
  }
}