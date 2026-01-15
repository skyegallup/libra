import 'package:libra/utils/models/gemtext_node.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';

class GemtextParser {
	List<GemtextNode> parse(String str) {
		// Set up output and state
		List<GemtextNode> nodes = [];

		bool isInPreformattedMode = false;
		String? currentPreText = null;
		String? currentPreAltText = null;

		// Parse line-by-line
		var lines = str.split(RegExp('\n'));
		if (lines[lines.length - 1] == '') {
			lines = lines.sublist(0, lines.length - 1);
		}

		for (var line in lines) {
			// Handle pre-formatted mode
			if (isInPreformattedMode) {
				if (line.startsWith('```')) {
					nodes.add(PreformattedTextNode(currentPreText!, currentPreAltText));
					
					isInPreformattedMode = false;
					currentPreText = null;
					currentPreAltText = null;

					continue;
				} else {
					currentPreText = currentPreText! + line;
					continue;
				}
			}

			if (line.startsWith('=>')) {
				var regex = RegExp(r'^=>[ \t]*([^\s]+)[ \t]*(.*)?$', multiLine: true);
				var match = regex.firstMatch(line);
				if (match != null) {
					nodes.add(LinkNode(match[1]!, match[2]));
					continue;
				}
			}

			if (line.startsWith('```')) {
				var followingText = line.substring(3).trim();
				var altText = followingText.length > 0 ? followingText : null;

				isInPreformattedMode = true;
				currentPreAltText = altText;
				currentPreText = '';
				continue;
			}

			if (line.startsWith('#')) {
				var level = 1;
				if (line[1] == '#') {
					level = 2;
					if (line[2] == '#') {
						level = 3;
					}
				}

				var text = line.substring(level).trim();
				nodes.add(HeadingNode(level, text));
				continue;
			}

			if (line.startsWith('* ')) {
				var text = line.substring(2).trim();
				nodes.add(ListNode(text));
				continue;
			}

			if (line.startsWith('>')) {
				var text = line.substring(1).trim();
				nodes.add(QuoteNode(text));
				continue;
			}

			// Assume all other lines are text nodes
			nodes.add(TextNode(line));
		}

		return nodes;
	}
}