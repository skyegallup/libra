import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_response.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<GeminiResponse>? _response;
  String url = 'gemini://m15o.midnight.pub';

  @override
  Widget build(BuildContext context) {
    return VBox(
      style: Style(
        $box.padding.all(16),
        $flex.gap(16)
      ),
      children: [
        PressableBox(
          onPress: () => _getCurrentUrl(context),
          child: StyledText('request')
        ),
        FutureBuilder<GeminiResponse>(
          future: _response,
          builder: (BuildContext context, AsyncSnapshot<GeminiResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return StyledText('Request not yet sent.');
            }

            if (snapshot.hasData) {
              return StyledText(snapshot.data!.content ?? '<no content>');
            }
            if (snapshot.hasError) {
              return StyledText('Request failed.');
            }

            return StyledText('Waiting...');
          },
        )
      ]
    );
  }

  void _getCurrentUrl(BuildContext context) {
    setState(() {
      _response = Provider.of<GeminiClient>(context, listen: false).get(url);
    });
  }
}
