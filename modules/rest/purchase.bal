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

// Retrieve all purchases
public isolated function getPurchases(mongodb:Database ecommerceDb) returns Purchase[]|error {
    mongodb:Collection purchases = check ecommerceDb->getCollection("purchases");
    stream<Purchase, error?> result = check purchases->find();
    return from Purchase p in result
        select p;
}

public isolated function getOnePurchase(mongodb:Database ecommerceDb, string purchaseId) returns Purchase|error {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");
    map<json> filter = {"purchaseId": purchaseId};

    mongodb:FindOptions findOptions = {};

    Purchase? foundPurchase = check purchasesCollection->findOne(filter, findOptions, (), Purchase);

    if foundPurchase is () {
        return error("Purchase with purchaseId '" + purchaseId + "' not found.");
    } else {
        return foundPurchase;
    }
}
//get purchases by shop id
public isolated function getPurchasesByShop(mongodb:Database ecommerceDb, string shopId) returns Purchase[]|error {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");
    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};
    stream<Purchase, error?> purchaseStream = check purchasesCollection->find(filter, findOptions, (), Purchase);
    Purchase[] purchases = [];
    check from var purchase in purchaseStream
        do {
            purchases.push(purchase);
    };
    if purchases.length() == 0 {
        return error("No purchases found for the shopId: " + shopId);
    }

    return purchases;
}

//insert a purchase
public isolated function insertPurchase(mongodb:Database ecommerceDb, Purchase newPurchase) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    map<json> filter = {"purchaseId": newPurchase.purchaseId};

    mongodb:FindOptions findOptions = {};

    Purchase? existingPurchase = check purchasesCollection->findOne(filter, findOptions, (), Purchase);

    if existingPurchase is () {
        check purchasesCollection->insertOne(newPurchase);
    } else {
        io:print("Purchase with purchaseId " + newPurchase.purchaseId + " already exists.");
    }
}

public isolated function insertMultiplePurchases(mongodb:Database ecommerceDb, Purchase[] newPurchases) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");

    check purchasesCollection->insertMany(newPurchases);
}

public isolated function updatePurchase(mongodb:Database ecommerceDb, string purchaseId, map<json> updates) returns error? {
    mongodb:Collection purchasesCollection = check ecommerceDb->getCollection("purchases");
    map<json> query = {"purchaseId": purchaseId};
    mongodb:Update updateData = {"set": updates};
    // Update the purchase's document
    anydata updateResult = check purchasesCollection->updateOne(query, updateData);
}
