import 'package:flutter/widgets.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:libra/views/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Add MixTheme
    return MultiProvider(
      providers: [
        Provider(create: (_) => GeminiClient())
      ],
      child: WidgetsApp(
        title: 'Libra',
        home: const HomePage(),
        color: Color.fromRGBO(0, 255, 0, 1.0),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context)
        )
      )
    );
  }
}
