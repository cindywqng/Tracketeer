//
//  VolunteerEntry.swift
//  Tracketeer
//
//  Created by Student on 7/9/25.
//

import Foundation

struct VolunteerEntry: Identifiable, Codable {
    var id = UUID()
    var projectName: String
    var hours: Double
    var photoData: Data?
    var date: Date
    var description: String
}
