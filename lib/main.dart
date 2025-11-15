import 'package:flutter/widgets.dart';
import 'package:libra/views/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Add MixTheme
    return WidgetsApp(
      title: 'Libra',
      home: const HomePage(),
      color: Color.fromRGBO(0, 255, 0, 1.0),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context)
      )
    );
  }
}
