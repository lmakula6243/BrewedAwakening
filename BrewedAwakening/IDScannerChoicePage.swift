import SwiftUI
import FirebaseDatabase
import FirebaseCore
struct IDScannerChoicePage: View {
    @State var scannedCode = ""
    @State var intScannedCode: Int?
    @State var showScanSheet = false
    @State var typedID = ""
    @State var showIDSheet = false
    @StateObject var myViewModel: StudentsViewModel = StudentsViewModel()
    @State var nameOfGroup: String = ""
    @Binding var group: Group
    var body: some View {
        
        VStack {
            Text("\(group.groupName)'s group is signing in")
                .font(.custom("Hiragino Kaku Gothic StdN", size: 35))
                .padding()
            VStack {
                List {
                    ForEach(myViewModel.students) { student in
                        HStack {
                            Text(student.firstname)
                            Text(student.lastname)
                            Text("Scanner ID: \(student.scannerId)")
                            Text("Student ID: \(student.id)")
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
                            .foregroundStyle(.black)
                            .font(.custom("Hiragino Kaku Gothic StdN", size: 20))
                            .padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 90)
                                .frame(width: 350, height: 300)
                                .foregroundStyle(Color.orange)
                            Image("Scanner")
                                .resizable()
                                .frame(width: 280, height: 280)
                            
                        }
                    }
                })
                .sheet(isPresented: $showScanSheet){
                    HStack{
                        Text("Scan Student ID")
                        
                        TextField("Waiting for scan…", text: $scannedCode)
                            .textFieldStyle(.roundedBorder)
                        
                            .onSubmit {
                                processScan()
                                //                                scannedCode = ""
                                showScanSheet = false
                            }
                    }
                }
                Button(action: {
                    showIDSheet.toggle()
                }, label: {
                    VStack {
                        Text("ID Button:")
                            .foregroundStyle(Color.black)
                            .font(.custom("Hiragino Kaku Gothic StdN", size: 20))
                            .padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 90)
                                .frame(width: 350, height: 300)
                                .foregroundStyle(Color.brown)
                            Image("Keypad")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                    }
                })
                .sheet(isPresented: $showIDSheet){
                    Text("Type Student ID")
                        .font(.largeTitle)
                    
                    TextField("Type Student ID here…", text: $typedID)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 400, height: 50)
                        .onSubmit {
                            processID(typedID)
                            typedID = ""
                        }
                    Image("Keypad")
                }
            }
        }
    }
    
        func processScan() {
            
            if let intScannedCode = Int(scannedCode) {
                myViewModel.getData(byField: "scannerId", value: intScannedCode)
            } else {
                print("Invalid scan")
            }
        }
        
        func processID(_ code: String){
            guard let intNumCode = Int(typedID) else{
                print("invaild id#")
                return
            }
            myViewModel.getData(byField: "id", value: intNumCode)
        }
    }
    
    

