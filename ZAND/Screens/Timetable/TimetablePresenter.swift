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

// при инициализации берем диапазон дат в 10 дней, начиная с первой и загружаем данные сразу

final class TimetablePresenter: TimetablePresenterOutput {

    // MARK: - Properties

    weak var view: TimetableInput?

    private let network: HTTP

    // MARK: - Initializers

    init(view: TimetableInput,
         network: HTTP,
         saloonID: Int,
         staffID: Int
    ) {
        self.view = view
        self.network = network

        self.fetchData(saloonID: saloonID, staffID: staffID, date: actualDate())
    }

    // MARK: - Instance methods

    private func fetchData(
        saloonID: Int,
        staffID: Int,
        date: String)
    {
        network.performRequest(type: .freeTime(
            company_id: saloonID,
            staff_id: staffID,
            date: date), expectation: TimetableModel.self)
        { [weak self] timetable in
            print(timetable.data.filter({ $0.is_free }))
        }
    }

    private func actualDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
