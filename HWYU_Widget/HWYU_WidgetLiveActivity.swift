//
//  HWYU_WidgetLiveActivity.swift
//  HWYU_Widget
//
//  Created by 이융의 on 12/13/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HWYU_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HWYU_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HWYU_WidgetAttributes.self) { context in
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

extension HWYU_WidgetAttributes {
    fileprivate static var preview: HWYU_WidgetAttributes {
        HWYU_WidgetAttributes(name: "World")
    }
}

extension HWYU_WidgetAttributes.ContentState {
    fileprivate static var smiley: HWYU_WidgetAttributes.ContentState {
        HWYU_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HWYU_WidgetAttributes.ContentState {
         HWYU_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HWYU_WidgetAttributes.preview) {
   HWYU_WidgetLiveActivity()
} contentStates: {
    HWYU_WidgetAttributes.ContentState.smiley
    HWYU_WidgetAttributes.ContentState.starEyes
}
