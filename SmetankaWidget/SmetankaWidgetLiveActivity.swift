//
//  SmetankaWidgetLiveActivity.swift
//  SmetankaWidget
//
//  Created by Димон on 25.09.23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SmetankaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SmetankaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SmetankaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SmetankaWidgetAttributes {
    fileprivate static var preview: SmetankaWidgetAttributes {
        SmetankaWidgetAttributes(name: "World")
    }
}

extension SmetankaWidgetAttributes.ContentState {
    fileprivate static var smiley: SmetankaWidgetAttributes.ContentState {
        SmetankaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SmetankaWidgetAttributes.ContentState {
         SmetankaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SmetankaWidgetAttributes.preview) {
   SmetankaWidgetLiveActivity()
} contentStates: {
    SmetankaWidgetAttributes.ContentState.smiley
    SmetankaWidgetAttributes.ContentState.starEyes
}
