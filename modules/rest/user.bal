import ballerina/io;
import ballerinax/mongodb;

public type User record {|
    string userId;
    string name;
    string email;
    string? phone;
    string? address;
    Order[]? orders;
    CartItem[]? cart;
    WishlistItem[]? wishlist;
    Notification[]? notifications;
|};

public type Order record {|
    string orderId;
|};

public type CartItem record {|
    string itemId;
    decimal itemPrice;
|};

public type WishlistItem record {|
    string itemId;
|};

public type Notification record {|
    string notificationId;
    string notificationText;
    string notificationDate;
    string notificationType;
|};

//get users
public isolated function getUsers(mongodb:Database ecommerceDb) returns User[]|error {
    mongodb:Collection users = check ecommerceDb->getCollection("users");
    stream<User, error?> result = check users->find();
    return from User u in result
        select u;
}
//get user by user id
public isolated function getOneUser(mongodb:Database ecommerceDb, string userId) returns User|error {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");
    map<json> filter = {"userId": userId};
    mongodb:FindOptions findOptions = {};
    User? foundUser = check usersCollection->findOne(filter, findOptions, (), User);

    if foundUser is () {
        return error("User with userId '" + userId + "' not found.");
    } else {
        return foundUser;
    }
}

//insert a new user to db
public isolated function insertUser(mongodb:Database ecommerceDb, User newUser) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");
    map<json> filter = {"userId": newUser.userId};
    mongodb:FindOptions findOptions = {};
    User? existingUser = check usersCollection->findOne(filter, findOptions, (), User);

    if existingUser is () {
        check usersCollection->insertOne(newUser);
    } else {
        io:print("User with userId " + newUser.userId + " already exists.");
    }
}

//insert multiple users 
public isolated function insertMultipleUsers(mongodb:Database ecommerceDb, User[] newUsers) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");
    check usersCollection->insertMany(newUsers);
}

public isolated function updateUser(mongodb:Database ecommerceDb, string userId, map<json> updates) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");

    map<json> query = {"userId": userId};

    mongodb:Update updateData = {"set": updates};

    // Update the user's document
    anydata updateResult = check usersCollection->updateOne(query, updateData);
}

