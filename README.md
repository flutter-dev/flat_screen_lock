# flat_screen_lock

Flat screen lock for Flutter.

![](http://o6p4e1uhv.bkt.clouddn.com/IMG_0462.JPG)

## How to use ?

1. Depend on it

```yaml
dependencies:
  flat_screen_lock: "^0.0.2"
```

2. Install it

```sh
$ flutter packages get
```

3. Import it

```dart
import 'package:flat_screen_lock/flat_screen_lock.dart';
```

## Example 

```dart
import 'package:flutter/material.dart';
import 'package:flat_screen_lock/flat_screen_lock.dart';
import 'package:flat_screen_lock_example/home_page.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var myCodes = [1, 2, 3, 4, 5, 6];
    return new Scaffold(
      body: new FlatScreenLockPage(
        title: "Enter Your Passcode",
        codeLength: myCodes.length,
        backgroundColor: new Color(0xff202835),
        foregroundColor: Colors.white,
        codeVerify: (List<int> codes) async {
          for (int i = 0; i < myCodes.length; i++) {
            if (codes[i] != myCodes[i]) {
              return false;
            }
          }          
          return true;
        },
        onVerified: () {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context){
            return new HomePage();
          }));
        }
      ),
    );
  }
}
```