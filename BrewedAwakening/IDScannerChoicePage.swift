import SwiftUI
//import FirebaseCore
struct IDScannerChoicePage: View {
    @State var scannedCode = ""
    @State var showScanSheet = false
    @State var typedID = ""
    @State var showIDSheet = false
    var body: some View {
        
        HStack{
            Button(action: {
                showScanSheet.toggle()
            }, label: {
                
                Text("Scanning Button: image of barcode")
                Image("Scanner")
                        })
                    }
        .sheet(isPresented: $showScanSheet){
            HStack{
                Text("Scan Student ID")
                    .font(.title)
                
                TextField("Waiting for scan…", text: $scannedCode)
                    .textFieldStyle(.roundedBorder)
                
                    .onSubmit {
                        processScan(scannedCode)
                        scannedCode = ""
                        showScanSheet = false
                    }
            }
        }
            Button(action: {
                showIDSheet.toggle()
            }, label: {
                Text("ID Button: image of numberPAD")
                Image("KeypadIcon")
                        })
                    
        .sheet(isPresented: $showIDSheet){
            Text("Scan Student ID")
                .font(.title)
            
            TextField("Type Student ID here…", text: $typedID)
                .textFieldStyle(.roundedBorder)
            
                .onSubmit {
                    processID(typedID)
                    typedID = ""
                }
                    }
    }
    func processScan(_ code: String){
        print("Scanned: \(code)")
    }
    func processID(_ code: String){
        print("Scanned: \(code)")
    }
}
