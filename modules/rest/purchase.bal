import ballerinax/mongodb;
import ballerina/io;


public type Purchase record {|
    string purchaseId;
    string userId;
    string shopId;
    PurchaseItem[] items;
    decimal totalAmount;
    string purchaseDate;
    string? deliveryDate;
    string? deliveryAddress;
    string? paymentMethod;
    string? paymentStatus;
    string? deliveryStatus;
|};

public type PurchaseItem record {|
    string itemId;
    decimal itemPrice;
    int itemQty;
|};

public isolated function getPurchases(mongodb:Database ecommerceDb) returns Purchase[]|error {
    mongodb:Collection purchases = check ecommerceDb->getCollection("purchases");
    stream<Purchase, error?> result = check purchases->find();
    return from Purchase p in result
        select p;
}

public isolated function getOnePurchase(mongodb:Database ecommerceDb, string purchaseId) returns Purchase|error {
    // Get the "purchases" collection from the MongoDB database
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    // Define the filter query to find the purchase by "purchaseId"
    map<json> filter = {"purchaseId": purchaseId};

    // Define the options for the findOne operation
    mongodb:FindOptions findOptions = {};

    // Perform the findOne operation to get the single purchase
    Purchase? foundPurchase = check purchasesCollection->findOne(filter, findOptions, (), Purchase);

    if foundPurchase is () {
        // Handle case where no purchase was found
        return error("Purchase with purchaseId '" + purchaseId + "' not found.");
    } else {
        // Return the found purchase
        return foundPurchase;
    }
}
public isolated function getPurchasesByShop(mongodb:Database ecommerceDb, string shopId) returns Purchase[]|error {
    // Get the "purchases" collection from the MongoDB database
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    // Define the filter query to find purchases by "shopId"
    map<json> filter = {"shopId": shopId};

    // Define the options for the find operation
    mongodb:FindOptions findOptions = {};

    // Perform the find operation to get all purchases for the given shopId
    stream<Purchase, error?> purchaseStream = check purchasesCollection->find(filter, findOptions, (), Purchase);

    // Create an array to hold the purchases
    Purchase[] purchases = [];

    // Collect the purchases from the stream into the array
    check from var purchase in purchaseStream
        do {
            purchases.push(purchase);
    };

    // Check if no purchases were found
    if purchases.length() == 0 {
        return error("No purchases found for the shopId: " + shopId);
    }

    // Return the found purchases
    return purchases;
}

public isolated function insertPurchase(mongodb:Database ecommerceDb, Purchase newPurchase) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    // Query to check if a purchase with the given purchaseId already exists
    map<json> filter = {"purchaseId": newPurchase.purchaseId};

    // Create an empty FindOptions object, as required by the findOne function
    mongodb:FindOptions findOptions = {};

    // Check if the purchase exists in the database
    Purchase? existingPurchase = check purchasesCollection->findOne(filter, findOptions, (), Purchase);

    if existingPurchase is () {
        // Purchase does not exist, proceed with inserting the new purchase
        check purchasesCollection->insertOne(newPurchase);
    } else {
        // Handle the case where the purchase already exists
        io:print("Purchase with purchaseId " + newPurchase.purchaseId + " already exists.");
    }
}

public isolated function insertMultiplePurchases(mongodb:Database ecommerceDb, Purchase[] newPurchases) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    // Insert multiple purchase documents into the collection
    check purchasesCollection->insertMany(newPurchases);
}

public isolated function updatePurchase(mongodb:Database ecommerceDb, string purchaseId, map<json> updates) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    // Define the query to find the purchase by purchaseId
    map<json> query = {"purchaseId": purchaseId};

    // Define the update operation using the $set operator
    mongodb:Update updateData = {"set": updates};

    // Update the purchase's document
    anydata updateResult = check purchasesCollection->updateOne(query, updateData);
}
