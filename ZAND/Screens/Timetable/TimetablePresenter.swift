//
//  TimetablePresenter.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import Foundation

protocol TimetablePresenterOutput: AnyObject {
    var workingRangeModel: [WorkingRangeItem] { get }
}

protocol TimetableInput: AnyObject {

}

// при инициализации берем диапазон дат в 10 дней, начиная с первой и загружаем данные сразу

final class TimetablePresenter: TimetablePresenterOutput {

    // MARK: - Properties

    weak var view: TimetableInput?

    var workingRangeModel: [WorkingRangeItem] = []

    private let network: HTTP

    private let scheduleTill: String

    // MARK: - Initializers

    init(view: TimetableInput,
         network: HTTP,
         saloonID: Int,
         staffID: Int,
         scheduleTill: String
    ) {
        self.view = view
        self.network = network
        self.scheduleTill = scheduleTill

        self.getWorkingRange() { [weak self] day in
            self?.fetchTimetableByDay(
                saloonID: saloonID,
                staffID: staffID,
                date: day.dateString
            )
        }
    }

    // MARK: - Instance methods

//    func currentDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: Date())
//    }

    private func fetchTimetableByDay(
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

    func getWorkingRange(completion: @escaping (WorkingRangeItem) -> Void) {
        let startDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.date(from: scheduleTill) ?? Date()

        var dateArray = [Date]()
        var currentDate = startDate
        while currentDate <= endDate {
            dateArray.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        dateArray.forEach { date in
            let dayNumericFormatter = DateFormatter()
            dayNumericFormatter.dateFormat = "dd"

            let dayStringFormatter = DateFormatter()
            dayStringFormatter.dateFormat = "E"

            let item = WorkingRangeItem(
                dateString: dateFormatter.string(from: date),
                dayNumeric: dayNumericFormatter.string(from: date),
                dayString: dayStringFormatter.string(from: date)
            )
            workingRangeModel.append(item)
        }

        if !workingRangeModel.isEmpty {
            completion(workingRangeModel.first!)
        }
    }
}
