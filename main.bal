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
//     String connectionString = "mongodb+srv://nipuna21:<db_password>@cluster0.a9vxy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
// Initialize MongoDB client
configurable string connectionString = "mongodb+srv://nipuna21:giselle123@cluster0.a9vxy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// Initialize MongoDB client using the connection string
final mongodb:Client mongoDb = check new ({
    connection: connectionString
});

service / on new http:Listener(9091) {
    private final mongodb:Database ecommerceDb;

    function init() returns error? {

        self.ecommerceDb = check mongoDb->getDatabase("ecommerce");
        io:println("REST api running on port 9091");
        return;
    }

    // Resource function to get items
    resource function get items() returns rest:Item[]|error {
        return rest:getItems(self.ecommerceDb); // Call the imported function
    }

    // Resource function to get shops
    resource function get shops() returns rest:Shop[]|error {
        return rest:getShops(self.ecommerceDb);
    }

    // Get a single shop by shopId
    resource function get shop/[string shopId]() returns rest:Shop|error {
        return rest:getOneShop(self.ecommerceDb, shopId);
    }

    // Insert a new shop
    resource function post shop(http:Request req) returns http:Response|error {
        json shopJson = check req.getJsonPayload();
        rest:Shop newShop = check shopJson.cloneWithType(rest:Shop);
        check rest:insertShop(self.ecommerceDb, newShop);

        json responseJson = {"success": true, "message": "User inserted successfully"};
        http:Response res = new;
        res.setJsonPayload(responseJson);
        return res;
    }

    // Update a shop by shopId
    resource function put shop/[string shopId](http:Request req) returns http:Response|error {
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            check rest:updateShop(self.ecommerceDb, shopId, updates);
            io:print("Shop updated successfully");
        }

        http:Response res = new;
        res.setTextPayload("Shop updated successfully");
        return res;
    }

    // Resource function to get users
    resource function get users() returns rest:User[]|error {
        return rest:getUsers(self.ecommerceDb); // Call the imported function
    }

    resource function get user/[string userId]() returns rest:User|error {
        // Call the getOneUser function to retrieve the user from the database
        rest:User|error result = rest:getOneUser(self.ecommerceDb, userId);

        // Check if the result is an error or a valid user
        if result is error {
            // If an error occurred, return the error response
            return error("User not found: " + result.message());
        } else {
            // Return the found user
            return result;
        }
    }

    resource function post user(http:Request req) returns http:Response|error {
        // Extract the new user from the request payload
        json userJson = check req.getJsonPayload();
        rest:User newUser = check userJson.cloneWithType(rest:User);

        // Call the insert function to add the user to the database
        check rest:insertUser(self.ecommerceDb, newUser);

        json responseJson = {"success": true, "message": "User inserted successfully"};
        http:Response res = new;
        res.setJsonPayload(responseJson);

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

