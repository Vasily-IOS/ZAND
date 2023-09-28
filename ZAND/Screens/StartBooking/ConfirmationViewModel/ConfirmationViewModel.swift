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
    var bookTime: String? = nil

    private let bookingType: BookingType
    private let id = 0
    private let appID = AppID.id

    // MARK: - Initializers

    init(bookingType: BookingType) {
        self.bookingType = bookingType

        self.fetchUserData()
    }

    // MARK: - Instance methods

    func build() {
        let appointmet = Appointment(
            id: id,
            services: [serviceID],
            staff_id: staffID,
            datetime: bookTime ?? "")
        
        let confirmationModel = ConfirmationModel(
            phone: phone,
            fullname: fullName,
            email: email,
            api_id: appID,
            appointments: [appointmet])

        resultModel = confirmationModel
    }

    private func fetchUserData() {
        let user = UserDBManager.shared.get()
        phone = "\(user?.phone ?? "")"
        fullName = "\(user?.familyName ?? "")" + "" + "\(user?.givenName ?? "")"
        email = "\(user?.email ?? "")"
    }
}
