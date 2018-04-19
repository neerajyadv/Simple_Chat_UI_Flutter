import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

const String _name = "Neeraj";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  MyChatScreen createState() => new MyChatScreen();
}

class MyChatScreen extends State<MyHomePage> with TickerProviderStateMixin
{
  //it is chat screen state

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Simple Chat Screen")),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(itemBuilder: (_, int index) => _messages[index],
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: _messages.length)),
          new Divider(height: 1.0,),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(child: new TextField(
              controller: _textEditingController,
              onChanged: (String text){
                setState((){
                  _isComposing = text.length > 0;});
                },
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration(hintText: "Send Message!"),)),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(icon: new Icon(Icons.send, color: Colors.redAccent,),
                  onPressed:_isComposing ? () => _handleSubmitted(_textEditingController.text):null
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _handleSubmitted(String text) {
    _textEditingController  .clear();
    setState((){_isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
        animationController: new AnimationController(
            vsync: this, duration: new Duration(milliseconds: 700))
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose()
  {
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget
{
  final String text;
  final AnimationController animationController;
  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(sizeFactor: new CurvedAnimation(parent: animationController, curve: Curves.decelerate),
    axisAlignment: 0.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0]))
          ),
          new Expanded(
            child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                )
              ],
            ),
          )
        ],
      ),
    )
    );
  }
}


