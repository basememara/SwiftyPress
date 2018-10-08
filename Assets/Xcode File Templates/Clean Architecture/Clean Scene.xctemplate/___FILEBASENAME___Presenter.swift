//___FILEHEADER___

import UIKit

struct ___VARIABLE_productName:identifier___Presenter: ___VARIABLE_productName:identifier___Presentable {
    private weak var viewController: ___VARIABLE_productName:identifier___Displayable?
    
    init(viewController: ___VARIABLE_productName:identifier___Displayable?) {
        self.viewController = viewController
    }
}

extension ___VARIABLE_productName:identifier___Presenter {

    func presentFetched(for response: ___VARIABLE_productName:identifier___Models.Response) {
        
    }
    
    func presentFetched(error: DataError) {
        let viewModel = AppModels.Error(
            title: "Error",
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}