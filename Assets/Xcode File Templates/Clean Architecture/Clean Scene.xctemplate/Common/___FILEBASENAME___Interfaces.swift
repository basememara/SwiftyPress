//___FILEHEADER___

protocol ___VARIABLE_productName:identifier___Displayable: class, AppDisplayable {
    func displayFetched(with viewModel: ___VARIABLE_productName:identifier___Models.ViewModel)
}

protocol ___VARIABLE_productName:identifier___BusinessLogic {
    func fetch(with request: ___VARIABLE_productName:identifier___Models.Request)
}

protocol ___VARIABLE_productName:identifier___Presentable {
    func presentFetched(for response: ___VARIABLE_productName:identifier___Models.Response)
    func presentFetched(error: DataError)
}

protocol ___VARIABLE_productName:identifier___Routable: AppRoutable {
    
}
