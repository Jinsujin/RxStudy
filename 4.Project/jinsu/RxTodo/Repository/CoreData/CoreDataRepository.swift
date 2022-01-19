import Foundation
import CoreData
import UIKit



final class CoreDataRepository: Repository {
    static var shared = CoreDataRepository()
    
    private let container: NSPersistentContainer!
    
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    
    func add(_ title: String, completion: ((Todo?) -> Void)?) {
        // Todo Entity를 가지고 오기
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoEntity", in: self.container.viewContext) else {
            return
        }
    
        let newData = Todo(title)
        
        // 2. NSManagedObject 만들기
        let todo = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        todo.setValue(newData.title, forKey: "title")
        todo.setValue(newData.isDone, forKey: "isDone")
        todo.setValue(newData.uid.uuidString, forKey: "uid")
    
        // 3. NSManagedObjectContext 에 저장
        do {
            try self.container.viewContext.save()
            completion?(newData)
        } catch {
            print(error.localizedDescription)
            completion?(nil)
        }
    }
    
    func delete(at uid: UUID, completion: ((Bool) -> Void)?) {
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let fetchResult = fetch(request: request)
        guard let deleteObject = fetchResult.filter({ $0.uid == uid.uuidString }).first else {
            completion?(false)
            return
        }
        self.context.delete(deleteObject)
        completion?(true)
    }
    
    
    func checkDone(at uid: UUID, completion: ((Todo?) -> Void)?) {
        
    }

    
    func deleteAll() -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    
    private func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    
    func fetchAll() -> [Todo] {
        do {
            guard let fetchTodoEntities = try self.context.fetch(TodoEntity.fetchRequest()) as? [TodoEntity] else {
                return []
            }
            let results = fetchTodoEntities.compactMap({ Todo(uid: $0.uid, title: $0.title, isDone: $0.isDone) })
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Model")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    var context: NSManagedObjectContext {
//        return self.persistentContainer.viewContext
        return self.container.viewContext
    }
}
