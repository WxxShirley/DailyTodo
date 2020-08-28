import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/common/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/common/hintToast.dart';
import 'package:todo/utils/updateTodos.dart';
import 'package:todo/widget/emojiPicker.dart';

// 主页
class CalendarPage extends StatefulWidget
{
  @override
  _CalendarPage createState() => new _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> with TickerProviderStateMixin
{
  // 每日活动
  Map<DateTime, List> _events;
  Map<String, String> _eventsTmp;
  
  // 每日心情
  Map<DateTime, List> _moods;
  Map<String, String> _moodsTmp;
  
  // 选中相关
  List _selectedEvents;
  DateTime _selectedDay;

  CalendarController _calendarController = new CalendarController();
  AnimationController _animationController;

  // "todo" form相关
  final _todokey = GlobalKey<FormState>();
  TextEditingController _todoController = new TextEditingController();
  
  // 加载待办
  Future<void> fetchTodos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    _eventsTmp = {};
    _events = {};

    if(prefs.containsKey("todos")){
      String tods = prefs.getString("todos");
      Map<String, dynamic> todosTmp = json.decode(tods);
       
      todosTmp.forEach((key, value) {
        List evts = value.split("\r\n");
        _events[DateTime.parse(key)] = evts;
        _eventsTmp[key]=value;
      });

    }
    if(_events.containsKey(_selectedDay)){
      _selectedEvents = _events[_selectedDay];
    }else{
      _selectedEvents = [];
    }
    
    setState(() {
      _events = _events;
      _eventsTmp = _eventsTmp;
      _selectedEvents = _selectedEvents;
    });
  }
  
  // 加载心情
  Future<void> fetchMoods() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    _moods={};
    _moodsTmp={};
    if(prefs.containsKey("moods")){
      Map<String,dynamic> mods = json.decode(prefs.getString("moods"));
      print(mods);
      mods.forEach((key, value) {
        print(key+value);
         _moods[DateTime.parse(key)] = [value];
         _moodsTmp[key] = value;
      });
    }
    setState(() {
      _moods = _moods;
      _moodsTmp = _moodsTmp;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime.now();

    fetchTodos();

    fetchMoods();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
    print('CALLBACK: _onDaySelected');
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }
  
  TextFormField _buildTodoTextField(){
    return TextFormField(
        autofocus: true,
        controller: _todoController,
        initialValue: null,
        decoration: InputDecoration(labelText: "待办事项"),
        validator: (String value){
          if(value.isEmpty)
            return "待办内容不能为空";
        },
    );
  }

 
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("日历"), 
        actions: <Widget>[
          IconButton(icon:Icon(Icons.add),onPressed: (){
            showModalBottomSheet(
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
              context: context,
              builder: (BuildContext context){
                String day = _selectedDay.toString().substring(0,10);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child:Text("为${day}添加", style: bottomHeaderStyle) ,
                      padding: EdgeInsets.symmetric(vertical:15.0),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.list,color:Colors.blue),
                      title: Text("待办事项", style:bottomTextStyle),
                      onTap:
                      () async{
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                             return AlertDialog(
                               content: Form(
                                 key: _todokey,
                                 child: _buildTodoTextField(),
                               ),
                               actions: [
                                 new FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("取消",style:bottomTextStyle.copyWith(color:Colors.grey))),
                                 new FlatButton(child: Text("确定",style: buttonText),onPressed: () async{
                                   print("pressed");
                                   if(_todokey.currentState.validate()){
                                     String newTodo = _todoController.text.toString();
                                     print("new TODO: "+newTodo);
                                     try{
                                       String day = _selectedDay.toString().substring(0,10);
                                       DateTime _day = DateTime.parse(day);

                                       if(_events.containsKey(_day)){
                                         _events[_day].add(newTodo);
                                       }else{
                                         _events[_day]=[newTodo];
                                       }

                                       if(_eventsTmp.containsKey(day)){
                                        String prev= _eventsTmp[day];
                                        _eventsTmp[day] = prev+"\r\n"+newTodo;
                                       }else{
                                         _eventsTmp[day]=newTodo;
                                       }
                                     
                                      setState(() {
                                         _events = _events;
                                         _selectedEvents = _events[_day];
                                         _eventsTmp = _eventsTmp;
                                         _todoController.text = "";
                                      });
                                       print(_eventsTmp);
                              
                                       updateTodo("todos",json.encode(_eventsTmp));
                                       
                                       Navigator.pop(context);
                                     }catch(err){
                                       print(err);
                                     }
                                     
                                    }
                                 } 
                                
                                 ),
                               ],
                             );
                        }
                     );
                      }
                    
                    ),
                    Divider(),

                    _moods.containsKey(DateTime.parse(_selectedDay.toString().substring(0,10)))?Container():
                    ListTile(
                      leading: Icon(Icons.favorite,color:Colors.blue),
                      title:Text("选择心情",style: bottomTextStyle),
                      onTap:() async{
                        // TODO
                        Navigator.pop(context);
                        final mood = await Navigator.push(context, 
                          new MaterialPageRoute(builder: (context) => new PickMood(date: _selectedDay.toString().substring(0,10)))
                        );
                        print("mood"+mood);
                        if(mood==""){
                          showToastWidget(HintToast(content: "还没有选择好心情",));
                        }else{
                          String day = _selectedDay.toString().substring(0,10);
                          DateTime _day = DateTime.parse(day);
                          _moods[_day] = [mood];
                          _moodsTmp[day] = mood;

                          updateTodo("moods", json.encode(_moodsTmp));
                          setState(() {
                            _moods = _moods;
                            _moodsTmp = _moodsTmp;
                          });

                        }
                       
                      }
                    ),
                  ],
                );
              }
            );
          },)
        ],   
      ),
      body: 
      
      (_events==null||_moods==null)?
        Center(child:CircularProgressIndicator())
         : 
        ListView(
        children: <Widget>[
           //_buildButtons(),
           const SizedBox(height: 8.0),
           _buildTableCalendarWithBuilders(),
           const SizedBox(height: 8.0),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'zh_CN',
      calendarController: _calendarController,
      events: _events,
      holidays: _moods,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: 6,
                top: 10,
                child: _buildHolidaysMarker(date),
              ),
            );
          }
          
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(DateTime data) {
    if(_moods.containsKey(data)&&_moods[data].length>=1)
       return Text(_moods[data][0]);
    return Text("");
  }
  
  // buttons for setting calendar mode
  Widget _buildButtons() {
    List<CalendarFormat> types = [CalendarFormat.month, CalendarFormat.twoWeeks, CalendarFormat.week];
    List<String> typeTexts = ["Month","2 Weeks","Week"];
    return 
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: 
            types.map((type) {
              return (
                RaisedButton(
                  child: Text(typeTexts[types.indexOf(type)]),
                  onPressed: (){
                    setState(() {
                      _calendarController.setCalendarFormat(type);
                    });
                  },
                )
              );
            }).toList(),
    );
  }
  


  // build events 
  Widget _buildEventList() {
    return 
      Column(children: 
        _selectedEvents.map((event)=>
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
           decoration: BoxDecoration(
             border: Border.all(width: 0.8,color:Colors.blue),
             borderRadius: BorderRadius.circular(12.0),
           ),
          child: Dismissible(
            background: Container(color:Colors.red, child:Icon(Icons.delete)),
            key: Key(event),
            onDismissed: (direction){
               String hint = "该活动已删除";
               String cmp = event;
               _selectedEvents.remove(event);

               String day = _selectedDay.toString().substring(0,10);
               DateTime _day = DateTime.parse(day);
               
               String newEvts = "";
               for(int i=0;i<_events[_day].length;++i){
                 if(_events[_day][i]!=cmp){
                   newEvts += _events[_day][i];
                   if(i!=_events[_day].length-1)
                      newEvts += "\r\n";
                 }
               }
               
               if(newEvts.length==0){ // 如果为空，需要删除键值
                 _events.remove(_day);
                 _eventsTmp.remove(day);
               }else{
                   _events[_day] = _selectedEvents;
                   _eventsTmp[day] = newEvts;
               }
            
               updateTodo("todos",json.encode(_eventsTmp));

               setState(() {
                  _selectedEvents = _selectedEvents;
                  _events = _events;
                  _eventsTmp = _eventsTmp;
               });
              showToastWidget(HintToast(content: hint));
            },
            child: 
            ListTile(
              title:Text(event.toString(), style: bottomTextStyle,),
              trailing: 
                Icon(Icons.check_circle, color:Colors.green),
            )
          )
        )
        ).toList(),
      );
  }
}
