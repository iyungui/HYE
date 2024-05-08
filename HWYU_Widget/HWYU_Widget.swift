//
//  HWYU_Widget.swift
//  HWYU_Widget
//
//  Created by 이융의 on 12/13/23.
//

import WidgetKit
import SwiftUI

struct DDayEntry: TimelineEntry {
    let date: Date
    let daysCount: Int
    let currentImageName: String
}

struct DDayProvider: TimelineProvider {
    func placeholder(in context: Context) -> DDayEntry {
        DDayEntry(date: Date(), daysCount: 100, currentImageName: "image01")
    }

    func getSnapshot(in context: Context, completion: @escaping (DDayEntry) -> Void) {
        let entry = DDayEntry(date: Date(), daysCount: 100, currentImageName: "image01")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DDayEntry>) -> Void) {
        let anniversaryDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
        let daysCount = Calendar.current.dateComponents([.day], from: anniversaryDate, to: Date()).day ?? 0
        let currentImageName = (1...7).map { String(format: "image%02d", $0) }.randomElement() ?? "image01"
        
        var entries: [DDayEntry] = []
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
            let entry = DDayEntry(date: entryDate, daysCount: daysCount, currentImageName: currentImageName)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DDayWidgetEntryView : View {
    var entry: DDayEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Text("우리가 함께한 지")
                .font(.footnote)

            HStack {
                Text("\(entry.daysCount)")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .italic()
                
                Image(systemName: "arrowshape.up.fill")
            }
            
            Text("2023.04.05")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .containerBackground(.fill, for: .widget)
    }
}

struct DDayWidget: Widget {
    let kind: String = "DDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DDayProvider()) { entry in
            DDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("D-Day Countdown")
        .description("Shows the number of days since a specific date.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct DDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        DDayWidgetEntryView(entry: DDayEntry(date: Date(), daysCount: 100, currentImageName: "image01"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
