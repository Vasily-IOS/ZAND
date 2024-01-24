//
//  TimetablePresenter.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

protocol TimetablePresenterOutput: AnyObject {
    var workingRangeModel: [WorkingRangeItemModel] { get set }
    var bookTimeModel: [BookTimeModel] { get set }
    var viewModel: ConfirmationViewModel { get set }
    func fetchBookTimes(date: String)
    func updateDateLabel(date: Date)
}

protocol TimetableInput: AnyObject {
    func reloadData()
    func reloadSection()
    func updateDate(date: String)
    func showIndicator(_ isShow: Bool)
}

final class TimetablePresenter: TimetablePresenterOutput {

    // MARK: - Properties

    weak var view: TimetableInput?

    var workingRangeModel: [WorkingRangeItemModel] = []

    var bookTimeModel: [BookTimeModel] = []

    var viewModel: ConfirmationViewModel

    private let network: APIManagerCommonP

    // MARK: - Initializers

    init(view: TimetableInput,
         network: APIManagerCommonP,
         viewModel: ConfirmationViewModel
    ) {

        self.view = view
        self.network = network
        self.viewModel = viewModel

        self.fetchBookDates(company_id: viewModel.company_id,
                            service_ids: [String(viewModel.bookService?.id ?? 0)],
                            staff_id: viewModel.staffID, date_to: viewModel.scheduleTill
        ) { [weak self] bookingDates in
            self?.setActualDates(dates: bookingDates) { firstDate in
                self?.view?.reloadData()
                self?.updateDateLabel(date: self?.workingRangeModel.first?.date ?? Date())
                self?.fetchBookTimes(date: firstDate)
            }
        }
    }

    deinit {
        print("TimetablePresenter died")
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
                company_id: viewModel.company_id,
                staff_id: viewModel.staffID,
                date: date,
                service_id: viewModel.bookService?.id ?? 0),
            expectation: BookTimesModel.self)
        { [weak self] bookTimes in

            self?.bookTimeModel = bookTimes.data
            self?.view?.showIndicator(false)
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

        view?.showIndicator(true)
        let model = FetchBookDateModel(
            company_id: company_id,
            service_ids: service_ids,
            staff_id: staff_id,
            date: currentDay,
            date_from: currentDay,
            date_to: date_to
        )
        network.performRequest(type: .bookDates(model), expectation: BookDatesModel.self)
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

            let item = WorkingRangeItemModel(
                dateString: dateFormatter.string(from: date),
                dayNumeric: dayNumericFormatter.string(from: date),
                dayString: dayStringFormatter.string(from: date)
            )
            workingRangeModel.append(item)
        }
        completion(dates.first ?? "")
    }
}
