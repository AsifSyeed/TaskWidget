//
//  TaskWidgetApp.swift
//  TaskWidgetApp
//
//  Created by Asif Syeed on 5/9/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let latestEntries = [TaskEntry(lastThreeTasks: latestTasks)]
        let timeline = Timeline(entries: latestEntries, policy: .atEnd)
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTasks: [TaskModel]
}

struct TaskWidgetAppEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Task's")
                .fontWeight(.bold)
        }
    }
}

struct TaskWidgetApp: Widget {
    let kind: String = "TaskWidgetApp"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskWidgetAppEntryView(entry: entry)
        }
        .configurationDisplayName("Task Widget")
        .description("This is an widget for interacting task list.")
    }
}

struct TaskWidgetApp_Previews: PreviewProvider {
    static var previews: some View {
        TaskWidgetAppEntryView(entry: TaskEntry(lastThreeTasks: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
