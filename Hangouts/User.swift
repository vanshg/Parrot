
// A chat user identifier.
// Use the much more full-featured User class for more data.
public struct UserID : Hashable, Equatable {
	public let chatID: String
	public let gaiaID: String
	
	// UserID: Equatable
	public var hashValue: Int {
		return chatID.hashValue &+ gaiaID.hashValue
	}
}

// UserID: Equatable
public func ==(lhs: UserID, rhs: UserID) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

// A chat user.
public struct User: Hashable, Equatable {
    public static let DEFAULT_NAME = "Unknown"
	
    public let id: UserID
	public let nameComponents: [String]
    public let photoURL: String?
    public let emails: [String]
    public let isSelf: Bool
	
	// Initialize a User directly.
	// Handles full_name or first_name being nil by creating an approximate
	// first_name from the full_name, or setting both to DEFAULT_NAME.
	//
	// Ignores firstName value.
    public init(userID: UserID, fullName: String? = nil, firstName: String? = nil,
		photoURL: String? = nil, emails: [String] = [], isSelf: Bool = false)
	{
		self.id = userID
		self.nameComponents = (fullName ?? User.DEFAULT_NAME).characters.split{$0 == " "}.map(String.init)
        self.photoURL = photoURL != nil ? "https:" + photoURL! : nil
        self.emails = emails
        self.isSelf = isSelf
    }
	
	// Initialize a User from an Entity.
	// If selfUser is nil, assume this is the self user.
    public init(entity: Entity, selfUser: UserID?) {
		let userID = UserID(chatID: entity.id!.chatId!,
			gaiaID: entity.id!.gaiaId! )
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
        self.init(userID: userID,
            fullName: entity.properties!.displayName as String?,
            firstName: entity.properties!.firstName as String?,
            photoURL: entity.properties!.photoUrl as String?,
            emails: entity.properties!.email.map { $0 as String },
            isSelf: isSelf
        )
    }
	
	// Initialize from ClientConversationParticipantData.
	// If selfUser is nil, assume this is the self user.
    public init(data: ConversationParticipantData, selfUser: UserID?) {
		let userID = UserID(chatID: data.id!.chatId!,
			gaiaID: data.id!.gaiaId!)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
        self.init(userID: userID,
            fullName: data.fallbackName,
            firstName: nil,
            photoURL: nil,
            emails: [],
            isSelf: isSelf
        )
	}
	
	// Computes the full name by taking the name components like so:
	// ["John", "Mark", "Smith"] => "John Mark Smith"
	// Will return an empty string if there are no name components.
	public var fullName: String {
		return self.nameComponents.joined(separator: " ")
	}
	
	// Computes the first name by taking the first of the name components:
	// ["John", "Mark", "Smith"] => "John"
	// Will return an empty string if there are no name components.
	public var firstName: String {
		return self.nameComponents.first ?? ""
	}
	
	// User: Hashable
	public var hashValue: Int {
		return self.id.hashValue
	}
}

// User: Equatable
public func ==(lhs: User, rhs: User) -> Bool {
	return lhs.id == rhs.id
}
