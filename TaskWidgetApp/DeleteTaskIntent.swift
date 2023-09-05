//
//  DeleteTaskIntent.swift
//  TaskWidget
//
//  Created by Asif Syeed on 5/9/23.
//

import SwiftUI
import AppIntents

struct DeleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Task"
    
    @Parameter(title: "Task ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        if let index = TaskDataModel.shared.tasks.firstIndex(where: {
            $0.id == id
        }) {
            TaskDataModel.shared.tasks.remove(at: index)
        }
        
        return .result()
    }
}
