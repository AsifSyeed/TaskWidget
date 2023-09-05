//
//  TaskWidgetApp.swift
//  TaskWidgetApp
//
//  Created by Asif Syeed on 5/9/23.
//

import WidgetKit
import SwiftUI
import AppIntents

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
            HStack {
                Text("Task's")
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 6, content: {
                if entry.lastThreeTasks.isEmpty {
                    Text("No new task")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(entry.lastThreeTasks.sorted {
                        !$0.isCompleted && $1.isCompleted
                    }) { task in
                        HStack(spacing: 6) {
                            Button(intent: ToggleStateIntent(id: task.id)) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .frame(width: 5, height: 5)
                            }
                            
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text(task.taskTitle)
                                    .lineLimit(1)
                                    .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                            })
                            
                            Spacer()
                            
                            Button(intent: DeleteTaskIntent(id: task.id)) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if task.id != entry.lastThreeTasks.last?.id {
                            Spacer(minLength: 0)
                        }
                    }
                }
            })
        }
        .padding(10)
        .containerBackground(.fill.tertiary, for: .widget)
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
        TaskWidgetAppEntryView(entry: TaskEntry(lastThreeTasks: TaskDataModel.shared.tasks))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
