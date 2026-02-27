import SwiftUI
import FirebaseDatabase
import FirebaseCore
import Combine

struct IDScannerChoicePage: View {
    @State var scannedCode = ""
    @State var intScannedCode: Int?
    @State var showScanSheet = false
    @State var typedID = ""
    @State var showIDSheet = false
    @StateObject var myViewModel: StudentsViewModel = StudentsViewModel()
    @StateObject var groupsVM: GroupsViewModel = GroupsViewModel()
    @State var nameOfGroup: String = ""
    @Binding var group: Group
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                            if let start = student.clockInTime {
                                Text(timeWorked(since: start))
                                    .font(.headline)
                            }
                        }
                        .listRowBackground(Color(.orange))
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let student = group.students[index]
                            
                            // Remove locally
                            group.students.remove(at: index)
                            
                            // Remove from Firebase
                            groupsVM.removeStudentFromGroup(
                                groupId: group.id,
                                student: student
                            )
                        }
                    }
                }
                .onReceive(myViewModel.$students) { newStudents in
                    guard let foundStudent = newStudents.last else { return }

                    
                    if !group.students.contains(where: { $0.id == foundStudent.id }) {
                        group.students.append(foundStudent)
                    }

                    groupsVM.addStudentToGroup(
                        groupId: group.id,   
                        student: foundStudent
                    )
                    
                    if let index = group.students.firstIndex(where: { $0.id == foundStudent.id }) {
                            

                            group.students[index].clockInTime = Date()
                            
                        } else {
                            var newStudent = foundStudent
                            
                            newStudent.clockInTime = Date()
                            
                            group.students.append(newStudent)
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
                        Text("Scan Student ID")
                            .font(.largeTitle)
                        
                        TextField("Waiting for scan…", text: $scannedCode)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 400, height: 50)
                        
                            .onSubmit {
                                processScan()
                                showScanSheet = false
                            }
                        
                        Image("Scanner")
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
        }.onReceive(timer) { _ in
            
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
    func timeWorked(since start: Date) -> String {
        let totalSeconds = Int(Date().timeIntervalSince(start))
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    }
    
    

