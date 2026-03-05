import SwiftUI
import FirebaseDatabase
import FirebaseCore
import Combine
import ConfettiSwiftUI

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
    @State var showCheckmark = false
    @State var confettiCounter = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack {
                Text("\(group.groupName)'s group is signing in")
                    .font(.custom("Hiragino Kaku Gothic StdN", size: 35))
                    .padding()
                VStack {
                    List {
                        ForEach(group.students, id: \.id) { student in
                            HStack {
                                Text(student.firstname)
                                Text(student.lastname)
                                Text("Scanner ID: \(student.scannerId)")
                                Text("Student ID: \(student.id)")
                            }
                            .listRowBackground(Color(.orange))
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let student = group.students[index]
                                
                                groupsVM.removeStudentFromGroup(
                                    groupId: group.id,
                                    student: student
                                )
                            }
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
                                checkMarkAnimation()
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
                                showIDSheet = false
                                checkMarkAnimation()
                            }
                        Image("Keypad")
                    }
                }
                
            }
            if showCheckmark == true {
                
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 500))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: showCheckmark)
                }
            }
        }
        .confettiCannon(
            trigger: $confettiCounter,
            num: 70,
            confettiSize: 18,
            radius: 400
            
        )
        .onReceive(timer) { _ in
            
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
    func checkMarkAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                showCheckmark = true
            }
        }
        confettiCounter += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation{
                showCheckmark = false
            }
        }
        
    }
    
    func removeStudentFromGroup(at offsets: IndexSet) {
                for index in offsets {
                    let student = myViewModel.students[index]
                    
                    myViewModel.students.remove(at: index)
                    group.students.removeAll { $0.id == student.id }
                    
                    groupsVM.removeStudentFromGroup(
                        groupId: group.id,
                        student: student
                    )
                }
            }

    }
    
    

