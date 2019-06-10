import 'package:flutter/material.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/utils/sysui_utils.dart';
import 'package:jobber/widgets/responsive_container.dart';
import 'package:shimmer/shimmer.dart';

class JobCard extends StatelessWidget{

  final Widget child;
  final String title;
  final bool isMini;
  final String description;
  final double heightPercent;
  final double widthModifier;
  final List<String> skills;
  final bool isLoading;

  const JobCard({
    Key key,
    this.child,
    this.isLoading = false,
    this.heightPercent,
    this.widthModifier,
    this.title="",
    this.isMini = false,
    this.description,
    this.skills
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          JobCardRoot(
            isLoading: isLoading,
            widthModifier: widthModifier,
            heightPercent: heightPercent,
            title:title,
            isMini: isMini,
            description: description,
            child: child,
            skills: skills,
          )
        ]),
      ),
    );
  }
}

class JobCardRoot extends StatelessWidget {
  final Widget child;
  final String title;
  final bool isMini;
  final String description;
  final double heightPercent;
  final isLoading;
  final double widthModifier;
  final List<String> skills;

  const JobCardRoot({
    Key key,
    this.child,
    this.isLoading = false,
    this.isMini,
    this.description,
    this.heightPercent,
    this.widthModifier,
    this.title="",
    this.skills,
  }):super(key: key);


  Widget _buildLoadingChip(context, double width){
    return Shimmer.fromColors(
      baseColor: JobberTheme.shimmerBaseColor(context),
      highlightColor: JobberTheme.shimmerHighlightColor(context),
      period: Duration(seconds: 1),
      direction: ShimmerDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8, right: 4),
        child: Container(
          width: width,
//        height: 0.05,
//          color: Colors.black,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(20.0),
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double aspect = queryData.size.width / queryData.size.height;

    List<Widget> skillChips = new List<Widget>();
    List<Widget> loadingSkillChips = new List<Widget>();

    skills.forEach((skill)=>skillChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: new ActionChip(
            label: isLoading?
                Text(skill,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    backgroundColor: Color(0xFF000000),
                  ),
                ):Text(skill,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
              ),
            ),
            backgroundColor: JobberTheme.accentColor,
            onPressed: ()=>{},
          ),
        )
    ));



    skills.forEach((skill)=>loadingSkillChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Container()
//          Shimmer.fromColors(
//            baseColor: Colors.grey[300],
//            highlightColor: Colors.grey[200],
//            period: Duration(seconds: 1),
//            direction: ShimmerDirection.ltr,
//            child: Container(
//              color: Colors.black,
////              decoration: BoxDecoration(
////                color: Colors.black,
////                borderRadius: BorderRadius.all(
////                    Radius.circular(15)
////                ),
////              ),
//            ),
//          ),
        )
    ));


    if (orientation == Orientation.portrait) {
      return Material(
        child: new Container(
//          child: Hero(
//            tag: 'propose_card'+title,
            child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.only(right: 10.0, left: 10.0),
                elevation: 16,
                child: new Center(
                  child: ResponsiveContainer(
                    heightPercent: isIPhoneX(context) ? heightPercent - 9 : heightPercent,
                    setwidthModifier: true,
                    widthModifier: widthModifier,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Hero(
                                    tag: 'propose_title'+title,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: isLoading?
                                      Shimmer.fromColors(
                                          baseColor: JobberTheme.shimmerBaseColor(context),
                                          highlightColor: JobberTheme.shimmerHighlightColor(context),
                                          period: Duration(seconds: 1),
                                          direction: ShimmerDirection.ltr,
                                          child:
                                      Text(
                                          title,
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            backgroundColor: Color(0xFF000000)
                                          )
                                      ),)
                                          :new Text(
                                          title,
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Hero(
                                tag: 'propose_details'+title,
                                child: Material(
                                  color: Colors.transparent,
                                  child: isLoading?
                                  Shimmer.fromColors(
                                    baseColor: JobberTheme.shimmerBaseColor(context),
                                    highlightColor: JobberTheme.shimmerHighlightColor(context),
                                    period: Duration(seconds: 1),
                                    direction: ShimmerDirection.ltr,
                                    child:
                                  Text(description,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    softWrap: false,
                                    style: TextStyle(
                                      backgroundColor: Color(0xFF000000)
                                    ),
                                  ),)
                                      :Text(description,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15,right: 15),
                              child: Hero(
                                tag: 'propose_skills'+title,
                                child: Material(
                                  color: Colors.transparent,
                                  child: isLoading ?
                                  ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      _buildLoadingChip(context, 75),
                                      _buildLoadingChip(context, 100),
                                      _buildLoadingChip(context, 50),
                                      _buildLoadingChip(context, 70),
                                    ],
                                  )
                                  :ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: skillChips
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),
//        ),
      );
    }else{
      return new Container(
//        child: new Card(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(15.0),
//          ),
//          margin: EdgeInsets.only(right: 5.0, left: 5.0),
//          elevation: 16,
//          child: new Center(
//              child: ResponsiveContainer(
//                heightPercent: isIPhoneX(context) ? heightPercent - 10 : heightPercent*3.5,
//                setwidthModifier: true,
//                widthModifier: aspect,
//                child: Column(
//                  children: <Widget>[
//                    SizedBox(height: 22),
//                    new Text(
//                        title,
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 20
//                        )
//                    ),
//                    child
//                  ],
//                ),
//              )
//          ),
//        ),
      );
    }
  }
}

class DoubleJobCard extends StatelessWidget {
  final String title;
  final String title2;
  final Widget child;
  final Widget child2;
  final double heightPercent;
  final double widthModifier;

  const DoubleJobCard({Key key, this.title, this.title2, this.child, this.child2, this.heightPercent, this.widthModifier}) : super(key: key);

  @override
  Widget build(BuildContext context){

    Orientation orientation = MediaQuery
        .of(context)
        .orientation;

    if (orientation == Orientation.portrait) {
      return new ResponsiveContainer(
          heightPercent: isIPhoneX(context) ? heightPercent - 10 : heightPercent,
          setwidthModifier: true,
          widthModifier: widthModifier,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
                  elevation: 16,
                  child: new Center(
                    child: ResponsiveContainer(
                      heightPercent: isIPhoneX(context) ? heightPercent*0.42 : heightPercent*0.474,
                      widthPercent: 100,
                      child: Column(
                        children: <Widget>[
                          ResponsiveContainer(heightPercent: 3, widthPercent: 3,),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: new Text(
                                title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: child,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(height: 31),
              new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
                  elevation: 16,
                  child: new Center(
                    child: ResponsiveContainer(
                      heightPercent: isIPhoneX(context) ? heightPercent* 0.42 : heightPercent*0.474,
                      widthPercent: 100,
                      child: Column(
                        children: <Widget>[
                          ResponsiveContainer(heightPercent: 3, widthPercent: 3,),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: new Text(
                                title2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: child2,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            ],
          )
      );
//      return new ResponsiveContainer(
//          heightPercent: heightPercent,
//          setwidthModifier: true,
//          widthModifier: widthModifier,
//          child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[ Container(
//            child: new Card(
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(15.0),
//                ),
//                margin: EdgeInsets.only(right: 15.0, left: 15.0),
//                elevation: 16,
//                child: new Center(
//                  child: ResponsiveContainer(
//                      heightPercent: heightPercent*0.474,
//                      setwidthModifier: true,
//                      widthModifier: widthModifier,
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(height: 22),
//                          FittedBox(
//                            fit: BoxFit.scaleDown,
//                            child: new Text(
//                                title,
//                                style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20
//                                )
//                            ),
//                          ),
//                          child
//                        ],
//                      ),
//                  ),
//                )
//            )
//          ),
//          SizedBox(height: 32),
//          Container(
//              child: new Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(15.0),
//                  ),
//                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
//                  elevation: 16,
//                  child: new Center(
//                    child: ResponsiveContainer(
//                        heightPercent: heightPercent*0.474,
//                        setwidthModifier: true,
//                        widthModifier: widthModifier,
//                        child: Column(
//                          children: <Widget>[
//                            SizedBox(height: 22),
//                            FittedBox(
//                              fit: BoxFit.scaleDown,
//                              child: new Text(
//                                  title2,
//                                  style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 20
//                                  )
//                              ),
//                            ),
//                            child2
//                          ],
//                        ),
//                    ),
//                  )
//              )
//          )]
//          )
//      );
    }else{
      return new ResponsiveContainer(
          heightPercent: heightPercent,
          widthModifier: widthModifier,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ Container(
                  child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.only(right: 15.0, left: 15.0),
                      elevation: 16,
                      child: new Center(
                        child: ResponsiveContainer(
                            heightPercent: heightPercent,
                            widthModifier: widthModifier,
                            child: child
                        ),
                      )
                  )
              ),
                SizedBox(height: 32),
                Container(
                    child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.only(right: 15.0, left: 15.0),
                        elevation: 16,
                        child: new Center(
                          child: ResponsiveContainer(
                              heightPercent: heightPercent,
                              widthModifier: widthModifier,
                              child: child2
                          ),
                        )
                    )
                )]
          )
      );
    }
  }
}