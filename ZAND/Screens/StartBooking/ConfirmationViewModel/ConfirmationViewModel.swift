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
}

final class ConfirmationViewModel {

    // MARK: - Properties

    var resultModel: ConfirmationModel?
    var phone = String()
    var fullName = String()
    var email = String()
    var serviceID = Int()
    var staffID = Int()
    var startSeanceDate: String?
    var startSeanceTime: String?
    var employeeCommon: EmployeeCommon?
    var bookService: BookService?
    var scheduleTill = String()
    var bookTime: BookTime? = nil {
        didSet {
            configureSeanceDate(model: bookTime)
        }
    }
    

    let company_id: Int
    let bookingType: BookingType
    
    private let id = 0

    // MARK: - Initializers

    init(bookingType: BookingType, company_id: Int) {
        self.bookingType = bookingType
        self.company_id = company_id

        self.fetchUserData()
    }

    deinit {
        print("❌ConfirmationViewModel died❌")
    }

    // MARK: - Instance methods

    func build() {
        let appointmet = Appointment(
            id: id,
            services: [serviceID],
            staff_id: staffID,
            datetime: bookTime?.datetime ?? "")
        
        let confirmationModel = ConfirmationModel(
            phone: phone.filter("0123456789".contains),
            fullname: fullName,
            email: email,
            api_id: AppID.id,
            appointments: [appointmet])

        resultModel = confirmationModel
    }

    private func configureSeanceDate(model: BookTime?) {
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
        let user = UserDBManager.shared.get()
        phone = "\(user?.phone ?? "")"
        fullName = "\(user?.familyName ?? "")" + "" + "\(user?.givenName ?? "")"
        email = "\(user?.email ?? "")"
    }
}
