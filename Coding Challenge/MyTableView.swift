import SwiftUI

struct MyTableView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyTableViewController {
        return MyTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyTableViewController, context: Context) {

    }
}

#Preview {
    MyTableView()
}
