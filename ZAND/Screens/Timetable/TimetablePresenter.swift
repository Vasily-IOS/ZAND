//
//  TimetablePresenter.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import Foundation

protocol TimetablePresenterOutput: AnyObject {

}

protocol TimetableInput: AnyObject {

}

final class TimeTablePresenter: TimetablePresenterOutput {

    // MARK: - Properties

    weak var view: TimetableInput?

    private let network: HTTP

    // MARK: - Initializers

    init(view: TimetableInput, network: HTTP, saloonID: Int, staffID: Int) {
        self.view = view
        self.network = network

        self.fetchData(saloonID: saloonID, staffID: staffID)
    }

    // MARK: - Instance methods

    private func fetchData(saloonID: Int, staffID: Int) {
//        network.performRequest(
//            type: .freeTime(
//                company_id: saloonID,
//                staff_id: staffID),
//            expectation: TimetableModel.self) { timetable in
//                print(timetable.meta)
//                print("Расписание сотрудника: \(timetable)")
//            }
    }
}
