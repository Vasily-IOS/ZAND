//
//  ConfirmationViewModel.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import UIKit

enum BookingType {
    case service
    case staff
    case `default`
}

final class ConfirmationViewModel {

    // MARK: - Properties

    var resultModel: ConfirmationModel?
    var companyName = String()
    var companyAddress = String()
    var phone = String()
    var fullName = String()
    var email = String()
    var staffID = Int()
    var startSeanceDate: String?
    var startSeanceTime: String?
    var employeeCommon: EmployeeCommon?
    var bookService: BookServiceModel?
    var scheduleTill = String()
    var bookTime: BookTimeModel? = nil {
        didSet {
            configureSeanceDate(model: bookTime)
        }
    }
    
    let company_id: Int
    let bookingType: BookingType
    
    private let id = 0

    // MARK: - Initializers

    init(
        bookingType: BookingType,
        company_id: Int,
        companyName: String,
        companyAddress: String
    ) {
        self.bookingType = bookingType
        self.company_id = company_id
        self.companyName = companyName
        self.companyAddress = companyAddress

        self.fetchUserData()
    }

    deinit {
        print("❌ConfirmationViewModel died❌")
    }

    // MARK: - Instance methods

    func build() {
        let appointmet = Appointment(
            id: id,
            services: [bookService?.id ?? 0],
            staff_id: staffID,
            datetime: bookTime?.datetime ?? "")
        
        let confirmationModel = ConfirmationModel(
            phone: phone.filter("0123456789".contains),
            fullname: fullName,
            email: email,
            api_id: ID.yclientsID,
            appointments: [appointmet])

        resultModel = confirmationModel
    }

    private func configureSeanceDate(model: BookTimeModel?) {
        let date = try? Date(bookTime?.datetime ?? "", strategy: .iso8601)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ru_RU")
        let seanceLength = "\((bookTime?.seance_length ?? 0)/60) мин."
        let seanceFullData = (bookTime?.time ?? "") + "," + " " + seanceLength

        startSeanceDate = formatter.string(from: date ?? Date())
        startSeanceTime = seanceFullData
    }

    private func fetchUserData() {
        let user = UserManager.shared.get()
        phone = "\(user?.phone ?? "")"
        fullName = "\(user?.name ?? "")" + " " + "\(user?.surname ?? "")"
        email = "\(user?.email ?? "")"
    }
}
