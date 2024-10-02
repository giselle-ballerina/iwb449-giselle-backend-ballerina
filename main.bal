import test2.rest;

import ballerina/http;
import ballerina/io;
import ballerinax/mongodb;

// Configurable values for MongoDB connection
configurable string host = "localhost";
configurable int port = 27017;
configurable string username = "testUser";
configurable string password = "testPassword";
configurable string database = "ecommerce";

// Initialize MongoDB client
final mongodb:Client mongoDb = check new ({
    connection: {
        serverAddress: {
            host,
            port
        },
        auth: <mongodb:ScramSha256AuthCredential>{
            username,
            password,
            database
        }
    }
});

service / on new http:Listener(9091) {
    private final mongodb:Database ecommerceDb;

    function init() returns error? {

        self.ecommerceDb = check mongoDb->getDatabase("ecommerce");

        return;
    }

    // Resource function to get items
    resource function get items() returns rest:Item[]|error {
        return rest:getItems(self.ecommerceDb); // Call the imported function
    }

    // Resource function to get shops
    resource function get shops() returns rest:Shop[]|error {
        return rest:getShops(self.ecommerceDb); // Call the imported function
    }

    // Resource function to get users
    resource function get users() returns rest:User[]|error {
        return rest:getUsers(self.ecommerceDb); // Call the imported function
    }

    resource function post user(http:Request req) returns http:Response|error {
        // Extract the new user from the request payload
        json userJson = check req.getJsonPayload();
        rest:User newUser = check userJson.cloneWithType(rest:User);

        // Call the insert function to add the user to the database
        check rest:insertUser(self.ecommerceDb, newUser);

        // Return a success response
        http:Response res = new;
        res.setTextPayload("User inserted successfully");
        return res;
    }

    // Update an existing user
    resource function put user/[string userId](http:Request req) returns http:Response|error {
        // Extract the updates from the request payload
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            // It's already a map<json>, so use it directly
            map<json> userMap = updates;
            // Call the update function to modify the user's data
            check rest:updateUser(self.ecommerceDb, userId, userMap);
            io:print("User updated successfully");
        }
        // Return a success response
        http:Response res = new;
        res.setTextPayload("User updated successfully");
        return res;
    }

    // Resource function to get purchases
    resource function get purchases() returns rest:Purchase[]|error {
        return rest:getPurchases(self.ecommerceDb); // Call the imported function
    }

    // Resource function to get offers
    resource function get offers() returns rest:Offer[]|error {
        return rest:getOffers(self.ecommerceDb); // Call the imported function
    }
}
