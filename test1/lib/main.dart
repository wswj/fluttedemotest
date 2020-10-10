import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Tools/SharedPreferencesTool.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        return Counter();
      })
    ],
    child: MyApp(),
  ));
  //设置状态栏背景色
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //系统底部状态栏颜色
      systemNavigationBarColor: Colors.black,
      //
      systemNavigationBarDividerColor: Colors.red,
      statusBarBrightness: Brightness.light);

  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class Counter with ChangeNotifier {
  double sliderVal = 0;
  var time = "DateTime.now()";
  increamentVal(val) {
    sliderVal = val;
    notifyListeners();
  }

  getTime() {
    return time;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //添加国际化支持
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh'),
        //const Locale('en'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// 1 ：轨道（Track），1 和 4 是有区别的，1 指的是底部整个轨道，轨道显示了可供用户选择的范围。对于从左到右（LTR）的语言，最小值出现在轨道的最左端，而最大值出现在最右端。对于从右到左（RTL）的语言，此方向是相反的。
// 2：滑块（Thumb），位置指示器，可以沿着轨道移动，显示其位置的选定值。
// 3：标签（label），显示与滑块的位置相对应的特定数字值。
// 4：刻度指示器（Tick mark），表示用户可以将滑块移动到的预定值。
class SliderTest extends StatelessWidget {
  const SliderTest({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var sliderProvider = Provider.of<Counter>(context);
    return Container(
      child: Column(
        children: [
          Text(sliderProvider.sliderVal.toString()),
          //基本使用
          // Slider(
          //     value: sliderProvider.sliderVal,
          //     onChanged: (val) {
          //       sliderProvider.increamentVal(val);
          //     })
          //设置最大值为100,离散值为4则可取的值只有0,25,50,100
          SliderTheme(
              data: SliderTheme.of(context)
                  .copyWith(thumbShape: SliderComponentShape.noThumb),
              child: Slider(
                  //激活部分的颜色
                  activeColor: Colors.red,
                  //未激活部分的颜色
                  inactiveColor: Colors.grey,
                  //离散值
                  divisions: 4,
                  //最小值
                  min: 0,
                  //最大值
                  max: 100,
                  //滑动组件当前值,可用于初始化,设为0时,不管如何滑动虽然滑动值仍会改变但是滑块的位置不变
                  value: sliderProvider.sliderVal,
                  //显示滑块的实时数值
                  label: sliderProvider.sliderVal.toString(),
                  onChanged: (val) {
                    sliderProvider.increamentVal(val);
                  }))
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class MaterialTimPickerTest extends StatelessWidget {
  const MaterialTimPickerTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            //Material风格时间选择器
            RaisedButton(
              child: Text("时间选择器"),
              onPressed: () {
                var material = showTimePicker(
                  helpText: "选择时间",
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child);
                  },
                );
                //使用24小时制
              },
            ),
            // IOS风格时间选择器
            RaisedButton(onPressed: () {
              //var iosdate=show
            }),
            RaisedButton(
                child: Text("用户登录表单"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text("用户登录"),
                        ),
                        content: LoginPage(),
                      );
                    },
                  );
                  //var iosdate=show
                })
          ],
        ),
      ),
    );
  }
}

///直接在页面上显示,而不是弹出,其方法参数和showDatePicker相同
class CalendarDatePickerTest extends StatelessWidget {
  const CalendarDatePickerTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      lastDate: DateTime(2030),
      firstDate: DateTime.now(),
      onDateChanged: (d) {
        print('$d');
      },
    );
  }
}

class ShowDateRangePicker extends StatelessWidget {
  const ShowDateRangePicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text("选择日期范围"),
          onPressed: () {
            var daterangepicker = showDateRangePicker(
                context: context,
                firstDate: DateTime(2010),
                lastDate: DateTime(2030));
          },
        ),
      ),
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
  void _incrementCounter() {}
  int currentIndex = 0;
  var homeWidgetList = [
    SliderTest(),
    MaterialTimPickerTest(),
    CalendarDatePickerTest(),
    ShowDateRangePicker(),
    InteractiveViewerTest()
  ];
  @override
  Widget build(BuildContext context) {
    var sliderProvider = Provider.of<Counter>(context);
    var prefs = PersistentStorage();
    double rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: IndexedStack(
          index: currentIndex,
          children: homeWidgetList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //获取选中的日期
          var date = await showDatePicker(
            locale: Locale("zh"),
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime(2030),
            //设置初始输入模式,默认为日历模式
            //initialEntryMode: DatePickerEntryMode.input,
            //设置日历日期选择器的初始显示，包含 day 和 year：
            //initialDatePickerMode: DatePickerMode.year,
            //设置顶部标题、取消按钮、确定按钮 文案
            helpText: "选择日期",
            cancelText: "取消",
            confirmText: "确定",
            errorFormatText: "日期格式错误",
            errorInvalidText: "请重新选择",
            fieldLabelText: "请输入日期(12/02/2012)",
            fieldHintText: "日/月/年",
            //设置可选日期范围
            selectableDayPredicate: (day) {
              return day.difference(DateTime.now()).inDays >= 0;
            },
            //设置深色主题
            builder: (context, child) {
              return Theme(data: ThemeData.dark(), child: child);
            },
          );
          //设置值
          prefs.setStorage("date", date.toString());
          //获取值
          prefs.getStorage("date").then((value) => sliderProvider.time = value);
          //print("object" + await prefs.getStorage("date").toString());
          showDialog(
            context: context,
            //点击弹窗以外的范围弹窗是否消失
            barrierDismissible: false,
            //弹窗范围以外的颜色
            barrierColor: Color.fromRGBO(1, 1, 1, 0),
            builder: (context) {
              return AlertDialog(
                elevation: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20 * rpx)),
                    side: BorderSide(
                        width: 2,
                        color: Colors.orange,
                        style: BorderStyle.solid)),
                title: Container(
                  width: 750 * rpx,
                  height: 50 * rpx,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Image.asset("lib/img/日期.png"), Text("请输入日期")],
                  ),
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("取消")),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"))
                ],
                content: Text(sliderProvider.getTime()),

                //shape: ShapeBorder(),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.date_range),
      ),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.blue),
          child: BottomNavigationBar(
              unselectedFontSize: 20 * rpx,
              selectedFontSize: 30 * rpx,
              selectedItemColor: Color.fromRGBO(244, 130, 34, 1),
              unselectedItemColor: Colors.white,
              unselectedLabelStyle: TextStyle(color: Colors.white),
              selectedLabelStyle:
                  TextStyle(color: Color.fromRGBO(244, 130, 34, 1)),
              type: BottomNavigationBarType.shifting,
              onTap: (index) {
                currentIndex = index;
                setState(() {});
              },
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit),
                    title: Text("data"),
                    backgroundColor: Colors.yellow),
                BottomNavigationBarItem(
                    icon: Icon(Icons.access_alarm),
                    title: Text("data"),
                    backgroundColor: Colors.green),
                BottomNavigationBarItem(
                    icon: Icon(Icons.access_time),
                    title: Text("data"),
                    backgroundColor: Colors.orange),
                BottomNavigationBarItem(
                    backgroundColor: Colors.purple,
                    icon: Icon(Icons.accessibility),
                    title: Text("data")),
                BottomNavigationBarItem(
                    backgroundColor: Colors.purple,
                    icon: Icon(Icons.shop_two),
                    title: Text("data"))
              ])), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class InteractiveViewerTest extends StatelessWidget {
  const InteractiveViewerTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: InteractiveViewer(child: Image.asset("lib/img/sights.jpg")),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwortController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                controller: _usernameController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "请输入手机号码",
                  labelText: "手机号",
                  prefixIcon: Icon(Icons.phone),
                  enabledBorder: InputBorder.none,
                  //获得焦点下划线设为蓝色
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  //使用正则表达式检验输入的手机号是否正确
                  return RegExp(
                              '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
                          .hasMatch(value)
                      ? null
                      : "手机号错误";
                },
              ),
              TextFormField(
                controller: _passwortController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "请输入密码",
                  labelText: "密码",
                  prefixIcon: Icon(Icons.vpn_key),
                  // 未获得焦点下划线设为灰色
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  //获得焦点下划线设为蓝色
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                //校验密码
                validator: (password) {
                  return password.length > 6 ? null : "密码不能少于6位数";
                },
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: RaisedButton(
                    child: Text("开始登录"),
                    onPressed: () {
                      //开始登录验证
                      if ((_formKey.currentState as FormState).validate()) {
                        print("验证通过");
                      }
                    }),
              )
            ],
          )),
    );
  }
}
