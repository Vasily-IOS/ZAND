//
//  VCFactory.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class ViewControllerFactoryImpl: ViewControllerFactory {
    func getViewController(for type: VCType) -> UIViewController {
        switch type {
        case .tabBar:
            let vc = TabBarController()
            return vc
        case .search(let model):
            let view = SearchView()
            let vc = SearchViewController(contentView: view)
            let presenter = SearchPresenter(view: vc, model: model)
            vc.presenter = presenter
            return vc
        case .main:
            let layotBuilder: DefaultMainLayout = MainLayout()
            let provider: SaloonProvider = SaloonProviderImpl()
            let view = MainView(layoutBuilder: layotBuilder)
            let vc = MainViewController(contentView: view)
            let presenter = MainPresenter(
                view: vc,
                provider: provider
            )
            vc.presenter = presenter
            return vc
        case .map:
            let view = MapView()
            let vc = MapViewController(contentView: view)
            let provider: SaloonProvider = SaloonProviderImpl()
            let presenter = MapPresenter(view: vc, provider: provider)
            vc.presenter = presenter
            return vc
        case .saloonDetail(let type):
            let view = SaloonDetailView()
            let vc = SaloonDetailViewController(contentView: view)
            let presenter = SaloonDetailPresenter(
                view: vc,
                type: type
            )
            vc.presenter = presenter
            return vc
        case .filter(let selectFilters):
            let layoutBuilder: DefaultFilterLayout = FilterLayout()
            let view = FilterView(layout: layoutBuilder)
            let vc = FilterViewController(contentView: view)
            let presenter = FilterPresenter(view: vc, selectFilters: selectFilters)
            vc.presenter = presenter
            return vc
        case .profile:
            let layout: DefaultProfileLayout = ProfileLayoutBuilder()
            let network: APIManager = APIManagerImpl()
            let view = ProfileView(layout: layout)
            let vc = ProfileViewController(contentView: view)
            let presenter = ProfilePresenter(view: vc, network: network)
            vc.presenter = presenter
            return vc
        case .appointments:
            let realmManager: RealmManager = RealmManagerImpl()
            let network: APIManager = APIManagerImpl()
            let view = AppointemtsView()
            let vc = AppointmentsViewController(contentView: view)
            let presenter = AppointmentsPresenterImpl(view: vc, network: network, realm: realmManager)
            vc.presenter = presenter
            vc.title = AssetString.books
            return vc
        case .privacyPolicy(let url):
            return PrivacyPolicyViewController(url: url)
        case .selectableMap(let model):
            let view = SelectableMapView()
            let vc = SelectableViewController(contentView: view)
            let presenter = SelectableMapPresenter(view: vc, model: model)
            vc.presenter = presenter
            return vc
        case .appleSignIn:
            let view = SignInView()
            let vc = SignInViewController(contentView: view)
            let presenter = SignInPresenter(view: vc)
            vc.presenter = presenter
            return vc
        case .register(let user):
            let view = RegisterView()
            let vc = RegisterViewController(contentView: view)
            let presenter = RegisterPresenter(view: vc, user: user)
            vc.presenter = presenter
            return vc
        case .startBooking(let company_id, let companyName, let companyAddress):
            let view = StartBookingView()
            let vc = StartBookingViewController(contentView: view)
            vc.title = AssetString.howStart
            let presenter = StartBookingPresenter(
                view: vc,
                company_id: company_id,
                companyName: companyName,
                saloonAddress: companyAddress
            )
            vc.presenter = presenter
            return vc
        case .services(let booking_type, let company_id, let company_name, let company_address, let viewModel):
            let view = ServicesView()
            let vc = ServicesViewController(contentView: view)
            let network: APIManager = APIManagerImpl()

            var currentViewModel: ConfirmationViewModel?

            if viewModel == nil {
                currentViewModel = ConfirmationViewModel(
                    bookingType: booking_type ?? .default,
                    company_id: company_id ?? 0,
                    companyName: company_name ?? "",
                    companyAddress: company_address ?? ""
                )
            } else {
                currentViewModel = viewModel
            }

            guard let currentViewModel = currentViewModel else { return UIViewController() }

            let presenter = ServicesPresenter(
                view: vc,
                network: network,
                viewModel: currentViewModel)

            vc.presenter = presenter

            vc.title = AssetString.service
            return vc

        case .staff(let booking_type, let company_id, let company_name, let company_address, let viewModel):
            let view = StaffView()
            let vc = StaffViewController(contentView: view)
            let network: APIManager = APIManagerImpl()

            var currentViewModel: ConfirmationViewModel?

            if viewModel == nil {
                currentViewModel = ConfirmationViewModel(
                    bookingType: booking_type ?? .default,
                    company_id: company_id ?? 0,
                    companyName: company_name ?? "",
                    companyAddress: company_address ?? ""
                )
            } else {
                currentViewModel = viewModel
            }

            guard let currentViewModel = currentViewModel else { return UIViewController() }

            let presenter = StaffPresenter(
                view: vc,
                network: network,
                viewModel: currentViewModel)
            vc.presenter = presenter
            vc.title = AssetString.staff
            return vc
        case .timeTable(let viewModel):
            let layout: DefaultTimetableLayout = TimetableLayout()
            let contentView = TimetableView(layout: layout)
            let vс = TimetableViewController(contentView: contentView)
            let network: APIManager = APIManagerImpl()
            let presenter = TimetablePresenter(
                view: vс,
                network: network,
                viewModel:  viewModel)
            vс.presenter = presenter
            vс.title = AssetString.selectDateAndTime
            return vс
        case .confirmation(let viewModel):
            let realm: RealmManager = RealmManagerImpl()
            let network: APIManager = APIManagerImpl()
            let view = ConfirmationView()
            let vc = ConfirmationViewController(contentView: view)
            let presenter = ConfirmationPresenter(
                view: vc,
                viewModel: viewModel,
                network: network,
                realm: realm
            )
            vc.presenter = presenter
            vc.title = AssetString.checkAppointment
            return vc
        }
    }
}
