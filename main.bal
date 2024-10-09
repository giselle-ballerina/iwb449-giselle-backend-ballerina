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

    // Resource function to get shops
    resource function get shops() returns rest:Shop[]|error {
        return rest:getShops(self.ecommerceDb);
    }

    // Get a single shop by shopId
    resource function get shop/[string shopId]() returns rest:Shop|error {
        return rest:getOneShop(self.ecommerceDb, shopId);
    }

    resource function get shop/user/[string userId]() returns rest:Shop|error {
        return rest:getOneShopByUser(self.ecommerceDb, userId);
    }

    // Insert a new shop
    resource function post shop(http:Request req) returns http:Response|error {
        json shopJson = check req.getJsonPayload();
        rest:Shop newShop = check shopJson.cloneWithType(rest:Shop);
        check rest:insertShop(self.ecommerceDb, newShop);

        http:Response res = new;
        res.setTextPayload("Shop inserted successfully");
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

        resource function get purchases() returns rest:Purchase[]|error {
        return rest:getPurchases(self.ecommerceDb); // Call the imported function
    }

        resource function get purchase/[string purchaseId]() returns rest:Purchase|error {
        // Call the getOnePurchase function to retrieve the purchase from the database
        rest:Purchase|error result = rest:getOnePurchase(self.ecommerceDb, purchaseId);

        // Check if the result is an error or a valid purchase
        if result is error {
            // If an error occurred, return the error response
            return error("Purchase not found: " + result.message());
        } else {
            // Return the found purchase
            return result;
        }
    }

    resource function post purchase(http:Request req) returns http:Response|error {
        // Extract the new purchase from the request payload
        json purchaseJson = check req.getJsonPayload();
        rest:Purchase newPurchase = check purchaseJson.cloneWithType(rest:Purchase);

        // Call the insert function to add the purchase to the database
        check rest:insertPurchase(self.ecommerceDb, newPurchase);

        // Return a success response
        http:Response res = new;
        res.setTextPayload("Purchase inserted successfully");
        return res;
    }

    resource function put purchase/[string purchaseId](http:Request req) returns http:Response|error {
        // Extract the updates from the request payload
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            // It's already a map<json>, so use it directly
            map<json> purchaseMap = updates;
            // Call the update function to modify the purchase's data
            check rest:updatePurchase(self.ecommerceDb, purchaseId, purchaseMap);
            io:print("Purchase updated successfully");
        }
        // Return a success response
        http:Response res = new;
        res.setTextPayload("Purchase updated successfully");
        return res;
    }


    // Resource function to get offers
    resource function get offers() returns rest:Offer[]|error {
        return rest:getOffers(self.ecommerceDb); // Call the imported function
    }
    resource function get offer/[string offerId]() returns rest:Offer|error {
        // Call the getOneOffer function to retrieve the offer from the database
        rest:Offer|error result = rest:getOneOffer(self.ecommerceDb, offerId);

        // Check if the result is an error or a valid offer
        if result is error {
        // If an error occurred, return the error response
            return error("Offer not found: " + result.message());
        } else {
        // Return the found offer
            return result;
        }
    }

    resource function post offer(http:Request req) returns http:Response|error {
        // Extract the new offer from the request payload
        json offerJson = check req.getJsonPayload();
        rest:Offer newOffer = check offerJson.cloneWithType(rest:Offer);

        // Call the insert function to add the offer to the database
        check rest:insertOffer(self.ecommerceDb, newOffer);

        // Return a success response
        http:Response res = new;
        res.setTextPayload("Offer inserted successfully");
        return res;
    }

    resource function put offer/[string offerId](http:Request req) returns http:Response|error {
        // Extract the updates from the request payload
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            // It's already a map<json>, so use it directly
            map<json> offerMap = updates;
            // Call the update function to modify the offer's data
            check rest:updateOffer(self.ecommerceDb, offerId, offerMap);
            io:print("Offer updated successfully");
        }
        // Return a success response
        http:Response res = new;
        res.setTextPayload("Offer updated successfully");
        return res;
    }


    resource function get items() returns rest:Item[]|error {
        return rest:getItems(self.ecommerceDb); // Call the imported function
    }
    resource function get item/[string itemId]() returns rest:Item|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Item|error result = rest:getOneItem(self.ecommerceDb, itemId);

        // Check if the result is an error or a valid item
        if result is error {
        // If an error occurred, return the error response
        return error("Item not found: " + result.message());
        } else {
        // Return the found item
        return result;
        }
    }

    resource function post item(http:Request req) returns http:Response|error {
        // Extract the new item from the request payload
        json itemJson = check req.getJsonPayload();
        rest:Item newItem = check itemJson.cloneWithType(rest:Item);

        // Call the insert function to add the item to the database
        check rest:insertItem(self.ecommerceDb, newItem);

        // Return a success response
        http:Response res = new;
        res.setTextPayload("Item inserted successfully");
        return res;
    }

    resource function put item/[string itemId](http:Request req) returns http:Response|error {
        // Extract the updates from the request payload
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            // It's already a map<json>, so use it directly
            map<json> itemMap = updates;
            // Call the update function to modify the item's data
            check rest:updateItem(self.ecommerceDb, itemId, itemMap);
            io:print("Item updated successfully");
        }
        // Return a success response
        http:Response res = new;
        res.setTextPayload("Item updated successfully");
        return res;
    }

}

