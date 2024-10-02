import ballerinax/mongodb;

public isolated function getPurchases(mongodb:Database ecommerceDb) returns Purchase[]|error {
    mongodb:Collection purchases = check ecommerceDb->getCollection("purchases");
    stream<Purchase, error?> result = check purchases->find();
    return from Purchase p in result
        select p;
}

// Define the necessary types for the items, shops, users, purchases, and offers

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
