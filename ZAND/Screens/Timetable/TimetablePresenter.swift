//
//  TimetablePresenter.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

protocol TimetablePresenterOutput: AnyObject {
    var workingRangeModel: [WorkingRangeItem] { get set }
    var bookTimeModel: [BookTime] { get set }
    func fetchBookTimes(date: String)
    func updateDateLabel(date: Date)
}

protocol TimetableInput: AnyObject {
    func reloadData()
    func reloadSection()
    func updateDate(date: String)
}

final class TimetablePresenter: TimetablePresenterOutput {

    // MARK: - Properties

    weak var view: TimetableInput?

    var workingRangeModel: [WorkingRangeItem] = []

    var bookTimeModel: [BookTime] = []

    private let network: HTTP

    private let saloonID: Int

    private let staffID: Int

    private let serviceToProvideID: Int

    private let scheduleTill: String

    // MARK: - Initializers

    init(view: TimetableInput,
         network: HTTP,
         saloonID: Int,
         staffID: Int,
         scheduleTill: String,
         serviceToProvideID: Int
    ) {
        self.view = view
        self.network = network
        self.saloonID = saloonID
        self.staffID = staffID
        self.scheduleTill = scheduleTill
        self.serviceToProvideID = serviceToProvideID

        self.fetchBookDates(company_id: saloonID,
                            service_ids: [String(serviceToProvideID)],
                            staff_id: staffID, date_to: scheduleTill
        ) { [weak self] bookingDates in
            self?.setActualDates(dates: bookingDates) { firstDate in
                self?.view?.reloadData()
                self?.updateDateLabel(date: self?.workingRangeModel.first?.date ?? Date())
                self?.fetchBookTimes(date: firstDate)
            }
        }
    }

    // MARK: - Instance methods

    func updateDateLabel(date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateStyle = .medium
        view?.updateDate(date: formatter.string(from: date))
    }

    func fetchBookTimes(date: String) {
        network.performRequest(
            type: .bookTimes(
                company_id: saloonID,
                staff_id: staffID,
                date: date,
                service_id: serviceToProvideID),
            expectation: BookTimes.self)
        { [weak self] bookTimes in
            self?.bookTimeModel = bookTimes.data
            self?.view?.reloadSection()
        }
    }

    private func fetchBookDates(
        company_id: Int,
        service_ids: [String],
        staff_id: Int,
        date_to: String, completion: @escaping (([String]) -> Void)
    ) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDay = formatter.string(from: Date())

        network.performRequest(type: .bookDates(
            company_id: company_id,
            service_ids: service_ids,
            staff_id: staff_id,
            date: currentDay,
            date_from: currentDay,
            date_to: date_to),
            expectation: BookDates.self
        )
        { bookDates in
            completion(bookDates.data.booking_dates)
        }
    }

    private func setActualDates(dates: [String], completion: @escaping (String) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datesData = dates.compactMap { dateFormatter.date(from: $0) }

        datesData.forEach { date in
            let dayNumericFormatter = DateFormatter()
            dayNumericFormatter.dateFormat = "dd"

            let dayStringFormatter = DateFormatter()
            dayStringFormatter.locale = Locale(identifier: "ru_RU")
            dayStringFormatter.dateFormat = "E"

            let item = WorkingRangeItem(
                dateString: dateFormatter.string(from: date),
                dayNumeric: dayNumericFormatter.string(from: date),
                dayString: dayStringFormatter.string(from: date)
            )
            workingRangeModel.append(item)
        }
        completion(dates.first ?? "")
    }
}
