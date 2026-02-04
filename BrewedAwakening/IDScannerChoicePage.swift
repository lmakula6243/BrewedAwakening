import SwiftUI
import FirebaseDatabase
import FirebaseCore
struct IDScannerChoicePage: View {
    @State var scannedCode = ""
    @State var showScanSheet = false
    @State var typedID = ""
    @State var showIDSheet = false
    @StateObject var myViewModel: StudentsViewModel = StudentsViewModel()

    var body: some View {
        
        VStack {
            List {
                ForEach(myViewModel.students) { student in
                    HStack{
                        Text(student.firstname)
                        Text(student.lastname)
                        Text(student.skey)
                       Text("\(student.scannerId)")
                        Text("\(student.id)")
                    }
                }
            }
        }
        HStack {
            Button(action: {
                showScanSheet.toggle()
            }, label: {
                VStack {
                    Text("Scan Button:" )
                    Image("Scanner")
                }
            })
            .buttonStyle(.borderedProminent)
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
                VStack {
                    Text("ID Button:")
                    Image("Keypad")
                }
            })
            .buttonStyle(.borderedProminent)
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
    }
    func processScan(_ code: String){
        print("Scanned: \(code)")
    }
    func processID(_ code: String){
        print("Scanned: \(code)")
    }
}
