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


public isolated function getUsers(mongodb:Database ecommerceDb) returns User[]|error {
    mongodb:Collection users = check ecommerceDb->getCollection("users");
    stream<User, error?> result = check users->find();
    return from User u in result
        select u;
}

public isolated function getOneUser(mongodb:Database ecommerceDb, string userId) returns User|error {
    // Get the "users" collection from the MongoDB database
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");

    // Define the filter query to find the user by "userId"
    map<json> filter = {"userId": userId};

    // Define the options for the findOne operation
    mongodb:FindOptions findOptions = {};

    // Perform the findOne operation to get the single user
    User? foundUser = check usersCollection->findOne(filter, findOptions, (), User);

    if foundUser is () {
        // Handle case where no user was found
        return error("User with userId '" + userId + "' not found.");
    } else {
        // Return the found user
        return foundUser;
    }
}

public isolated function insertUser(mongodb:Database ecommerceDb, User newUser) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");

    // Query to check if a user with the given userId already exists
    map<json> filter = {"userId": newUser.userId};

    // Create an empty FindOptions object, as required by the findOne function
    mongodb:FindOptions findOptions = {};

    // Check if the user exists in the database
    User? existingUser = check usersCollection->findOne(filter, findOptions, (), User);

    if existingUser is () {
        // User does not exist, proceed with inserting the new user
        check usersCollection->insertOne(newUser);
    } else {
        // Handle the case where the user already exists
        io:print("User with userId " + newUser.userId + " already exists.");
    }
}

public isolated function insertMultipleUsers(mongodb:Database ecommerceDb, User[] newUsers) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");

    // Insert multiple user documents into the collection
    check usersCollection->insertMany(newUsers);
}

public isolated function updateUser(mongodb:Database ecommerceDb, string userId, map<json> updates) returns error? {
    mongodb:Collection usersCollection = check ecommerceDb->getCollection("users");

    // Define the query to find the user by userId
    map<json> query = {"userId": userId};

    // Define the update operation using the $set operator
    mongodb:Update updateData = {"set": updates};

    // Update the user's document
    anydata updateResult = check usersCollection->updateOne(query, updateData);
}

