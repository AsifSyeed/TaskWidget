//
//  TaskModel.swift
//  TaskWidget
//
//  Created by Asif Syeed on 5/9/23.
//

import Foundation

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
}

class TaskDataModel {
    static let shared = TaskDataModel()
    
    var tasks: [TaskModel] = [
        .init(taskTitle: "Combine"),
        .init(taskTitle: "WidgetKit"),
        .init(taskTitle: "MapKit")
    ]
}
