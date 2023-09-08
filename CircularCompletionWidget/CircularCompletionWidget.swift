//
//  CircularCompletionWidget.swift
//  CircularCompletionWidget
//
//  Created by Joynal Abedin on 8/9/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct CircularCompletionWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularCloseView()
        case .accessoryCorner:
            GaugeSample()
        case .accessoryInline:
            CircularCloseView()
        case .accessoryRectangular:
            CircularCloseView()
            
        @unknown default:
            VStack {
                HStack {
                    Text("Time:")
                    Text(entry.date, style: .time)
                }
            
                Text("Joynal Vai")
                Text(entry.configuration.favoriteEmoji)
            }
        }
    }
}

@main
struct CircularCompletionWidget: Widget {
    let kind: String = "CircularCompletionWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CircularCompletionWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    CircularCompletionWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}    


//All Circular View
struct CircularCloseView: View {
    var body: some View {
        ZStack {
            ProgressView(
                "25",
                value: (1.0 - 0),
                total: 1.0)
            .progressViewStyle(
                CircularProgressViewStyle(tint: .blue))
        }
    }
}

struct GaugeSample: View {
    @State var acidity = 5.8
    
    var body: some View {
        Gauge(value: acidity, in: 3...10) {
            Image(systemName: "drop.fill")
                .foregroundColor(.green)
        } currentValueLabel: {
            Text("\(acidity, specifier: "%.1f")")
        } minimumValueLabel: {
            Text("3")
        } maximumValueLabel: {
            Text("10")
        }
        .gaugeStyle(CircularGaugeStyle())
    }
}
