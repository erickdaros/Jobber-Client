import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobber/themes/jobber_theme.dart';

import 'dropdown_formfield.dart';

class SkillTextField extends StatefulWidget {

  final Key key;
  final TextEditingController controller;
  final Function onGetPosition;
  final Function onDelete;
  final bool autoValidate;
  final List<String> skills;
  final Function enableAdd;

  SkillTextField({this.key, @required this.controller, this.onDelete, this.onGetPosition, this.autoValidate, this.skills, this.enableAdd}) : super(key: key);

  @override
  State createState() => _SkillTextFieldState();
}

class _SkillTextFieldState extends State<SkillTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.onGetPosition(widget.key);
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionColor: JobberTheme.whiteStatusBar,
        textSelectionHandleColor:  JobberTheme.whiteStatusBar,
        accentColor:  JobberTheme.whiteStatusBar,
        primaryColor:  JobberTheme.whiteStatusBar,
      ),
      child: Padding(
        key: widget.key,
        padding: const EdgeInsets.only(top: 15,),
        child:  DropDownFormField(
            value: widget.skills,
            required: true,
            labelText: 'Skill',
            controller: widget.controller,
            items: widget.skills,
            onDelete: widget.onDelete,
            onGetPosition: widget.onGetPosition,
            index: index,
            keyValue: widget.key,
            enableAdd: widget.enableAdd,
            setter: (dynamic newValue) {
//              accountname = newValue;
            }
        ),
//        child: TextFormField(
//          cursorColor: JobberTheme.white,
////          focusNode: titleFocusNode,
//          controller: widget.controller,
//          textInputAction: TextInputAction.done,
//          onFieldSubmitted: (v){
////            FocusScope.of(context).requestFocus(descriptionFocusNode);
//          },
//          decoration: new InputDecoration(
//              border: OutlineInputBorder(
//                  borderSide: BorderSide(
//                      color: JobberTheme.whiteAppBar
//                  )
//              ),
//              isDense: true,
//              labelText: "Skill",
//              helperText: index==0?"Requer ao menos uma Skill":"",
//              suffixIcon: index!=0?IconButton(
//                  icon: Icon(
//                    FontAwesomeIcons.trashAlt,
//                    size: 20,
//                  ),
//                  onPressed: (){
//                    int index = widget.onGetPosition(widget.key);
//                    if(index==0){
//
//                    }else if(index == -1){
//
//                    }else{
//                      widget.onDelete(index);
//                    }
//                  }
//              ):null,
//          ),
//          maxLength: 20,
//          onSaved: (value){},
//          validator: index==0?(value) {
//            if(value.length < 2)
//              return 'Mínimo 2 caracteres válidos';
//            if(value.isEmpty){
//              return "Este campo não pode ser vazio";
//            }
//            if(value.trim()==null||value.trim()==""){
//              return 'Mínimo 2 caracteres válidos';
//            }
//            else
//              return null;
//          }:(value) {
//            if(value.trim()!=""){
//              if(value.length < 2)
//                return 'Mínimo 2 caracteres válidos';
//            }
//            else
//              return null;
//          },
//        ),
      ),
    );
  }
}