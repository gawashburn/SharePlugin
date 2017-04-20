import Cocoa
import MartaApi

public class OrgYanexSharePlugin : NSObject, Plugin, ActionProvider {
    public let name = "Share"
    public let author = "Yan Zhulanow"
    public let email = "mail@yanex.org"
    
    public let requiredApiVersion = ApiVersion.forMartaVersion(release: 0, major: 2)
    
    public var actions: [Action] {
        return [ OrgYanexShareAction() ]
    }
}

class OrgYanexShareAction : Action {
    let id = "org.yanex.share"
    let name = "Share"
    
    func isApplicable(context: ActionContext) -> Bool {
        let model = context.activePane.mutableModel
        return model.directoryData?.directory is LocalFile && 
            !context.activePane.mutableModel.activeItems.isEmpty
    }
    
    func apply(context: ActionContext) {
        let filesToShare = context.activePane.mutableModel.activeItems
            .flatMap { $0 as? LocalFile }
            .map { $0.url }
        
        let view = context.activePane.view
        guard let currentItemRect = view.currentItemRect else { return }
        
        let picker = NSSharingServicePicker(items: filesToShare)
        picker.show(
            relativeTo: currentItemRect.offsetBy(dx: 10, dy: 10),
            of: view.fileListView, 
            preferredEdge: .minX)
    }
}
