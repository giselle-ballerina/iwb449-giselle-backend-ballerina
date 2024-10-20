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
configurable string connectionString = "mongodb+srv://nipuna21:giselle123@cluster0.a9vxy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// Initialize MongoDB client using the connection string
final mongodb:Client mongoDb = check new ({
    connection: connectionString
});
SearchServiceClient ep = check new ("http://139.59.246.168:50051");
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
        return rest:getUsers(self.ecommerceDb); 
    }

    //get one user by userId
    resource function get user/[string userId]() returns rest:User|error {
        rest:User|error result = rest:getOneUser(self.ecommerceDb, userId);

        if result is error {
            return error("User not found: " + result.message());
        } else {
            return result;
        }
    }

    resource function post user(http:Request req) returns http:Response|error {
        // Extract the new user from the request payload
        json userJson = check req.getJsonPayload();
        rest:User newUser = check userJson.cloneWithType(rest:User);

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
            map<json> userMap = updates;
            // Call the update function to modify the user's data
            check rest:updateUser(self.ecommerceDb, userId, userMap);
            io:print("User updated successfully");
        }
        http:Response res = new;
        res.setTextPayload("User updated successfully");
        return res;
    }
    //get purchases
    resource function get purchases() returns rest:Purchase[]|error {
        return rest:getPurchases(self.ecommerceDb); 
    }

    
    resource function get purchase/[string purchaseId]() returns rest:Purchase|error {
        // Call the getOnePurchase function to retrieve the purchase from the database
        rest:Purchase|error result = rest:getOnePurchase(self.ecommerceDb, purchaseId);
        if result is error {
            return error("Purchase not found: " + result.message());
        } else {
            return result;
        }
    }
    resource function get purchase/shop/[string shopId]() returns rest:Purchase[]|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Purchase[]|error result = rest:getPurchasesByShop(self.ecommerceDb, shopId);

        if result is error {
            return error("purchases not found: " + result.message());
        } else {
            return result;
        }
    }
    resource function post purchase(http:Request req) returns http:Response|error {
        json purchaseJson = check req.getJsonPayload();
        rest:Purchase newPurchase = check purchaseJson.cloneWithType(rest:Purchase);

        // Call the insert function to add the purchase to the database
        check rest:insertPurchase(self.ecommerceDb, newPurchase);
        http:Response res = new;
        res.setTextPayload("Purchase inserted successfully");
        return res;
    }

    resource function put purchase/[string purchaseId](http:Request req) returns http:Response|error {
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            map<json> purchaseMap = updates;
            check rest:updatePurchase(self.ecommerceDb, purchaseId, purchaseMap);
            io:print("Purchase updated successfully");
        }
        http:Response res = new;
        res.setTextPayload("Purchase updated successfully");
        return res;
    }

    // Resource function to get offers
    resource function get offers() returns rest:Offer[]|error {
        return rest:getOffers(self.ecommerceDb); 
    }

    resource function get offer/[string offerId]() returns rest:Offer|error {
        // Call the getOneOffer function to retrieve the offer from the database
        rest:Offer|error result = rest:getOneOffer(self.ecommerceDb, offerId);

        if result is error {
            return error("Offer not found: " + result.message());
        } else {
            return result;
        }
    }
    resource function get offer/shop/[string shopId]() returns rest:Offer[]|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Offer[]|error result = rest:getOneOfferShop(self.ecommerceDb, shopId);

        if result is error {
            return error("Offers not found: " + result.message());
        } else {
            return result;
        }
    }

    resource function post offer(http:Request req) returns http:Response|error {
        // Extract the new offer from the request payload
        json offerJson = check req.getJsonPayload();
        rest:Offer newOffer = check offerJson.cloneWithType(rest:Offer);
        check rest:insertOffer(self.ecommerceDb, newOffer);
        http:Response res = new;
        res.setTextPayload("Offer inserted successfully");
        return res;
    }

    resource function put offer/[string offerId](http:Request req) returns http:Response|error {
        // Extract the updates from the request payload
        json updates = check req.getJsonPayload();
        if updates is map<json> {
            map<json> offerMap = updates;
            check rest:updateOffer(self.ecommerceDb, offerId, offerMap);
            io:print("Offer updated successfully");
        }
        http:Response res = new;
        res.setTextPayload("Offer updated successfully");
        return res;
    }

    resource function get items() returns rest:Item[]|error {
        return rest:getItems(self.ecommerceDb); 
    }
    resource function get recommendedItems(http:Caller caller, http:Request req) returns error? {
        // Extract query and top_k from request parameters
        string query = req.getQueryParamValue("query") ?: "default_query";
        int top_k = check 'int:fromString(req.getQueryParamValue("top_k") ?: "5");

        //Call the gRPC service to get the search response (which includes the itemIds)
        QueryRequest performSearchRequest = {query: query, top_k: top_k};
        SearchResponse performSearchResponse = check ep->PerformSearch(performSearchRequest);

        // Extract itemIds from the gRPC response
        string[] itemIds = from var item in performSearchResponse.item_ids select item;
        io:println("ItemIds: ", itemIds);
        rest:Item[] recommendedItems = check rest:getRecommendedItems(self.ecommerceDb, itemIds);

        check caller->respond(recommendedItems);
    }
    resource function get item/[string itemId]() returns rest:Item|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Item|error result = rest:getOneItem(self.ecommerceDb, itemId);
        if result is error {
            return error("Item not found: " + result.message());
        } else {
            return result;
        }
    }

    
    resource function get item/shop/[string shopId]() returns rest:Item[]|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Item[]|error result = rest:getItemsByShop(self.ecommerceDb, shopId);

        if result is error {
            return error("Item not found: " + result.message());
        } else {
            return result;
        }
    }

    resource function get item/price/[decimal priceUpperBound]/[decimal priceLowerBound]() returns rest:Item[]|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Item[]|error result = rest:filterItemsbyPrice1(self.ecommerceDb, priceLowerBound, priceUpperBound);
        if result is error {
            return error("Item not found: " + result.message());
        } else {
            return result;
        }
    }

    resource function get item/priceUpper/[decimal priceUpperBound]/[decimal priceLowerBound]() returns rest:Item[]|error {
        // Call the getOneItem function to retrieve the item from the database
        rest:Item[]|error result = rest:filterItemsbyPrice2(self.ecommerceDb, priceUpperBound);
        if result is error {
            return error("Item not found: " + result.message());
        } else {
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
            map<json> itemMap = updates;
            // Call the update function to modify the item's data
            check rest:updateItem(self.ecommerceDb, itemId, itemMap);
            io:print("Item updated successfully");
        }
        http:Response res = new;
        res.setTextPayload("Item updated successfully");
        return res;
    }

}