import ballerina/io;
import ballerinax/mongodb;

public type Shop record {|
    string shopId;
    string shopName;
    Owner owner;
    string? description;
    string? background;
    Color? color;
    string? logo;
    Font? font;
    Insight[]? insights;
|};

public type Owner record {|
    string name;
    string email;
    string userId;
    string? phone;
    string? address;
|};

public type Color record {|
    string primary;
    string secondary;
|};

public type Font record {|
    string primary;
    string secondary;
|};

public type Insight record {|
    int totalViews;
    int totalLikes;
    int totalShares;
    int totalOrders;
    decimal totalRevenue;
    int totalProducts;
|};

public isolated function getShops(mongodb:Database ecommerceDb) returns Shop[]|error {
    mongodb:Collection shops = check ecommerceDb->getCollection("shops");
    stream<Shop, error?> result = check shops->find();
    return from Shop s in result
        select s;
}

// Retrieve a single shop by shopId
public isolated function getOneShop(mongodb:Database ecommerceDb, string shopId) returns Shop|error {
    mongodb:Collection shopsCollection = check ecommerceDb->getCollection("shops");

    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};

    Shop? foundShop = check shopsCollection->findOne(filter, findOptions, (), Shop);

    if foundShop is () {
        return error("Shop with shopId '" + shopId + "' not found.");
    } else {
        return foundShop;
    }
}

public isolated function getOneShopByUser(mongodb:Database ecommerceDb, string userId) returns Shop|error {
    mongodb:Collection shopsCollection = check ecommerceDb->getCollection("shops");

    map<json> filter = {"owner.userId": userId};
    mongodb:FindOptions findOptions = {};

    Shop? foundShop = check shopsCollection->findOne(filter, findOptions, (), Shop);

    if foundShop is () {
        return error("Shop with shopId '" + userId + "' not found.");
    } else {
        return foundShop;
    }
}

// Insert a new shop
public isolated function insertShop(mongodb:Database ecommerceDb, Shop newShop) returns error? {
    mongodb:Collection shopsCollection = check ecommerceDb->getCollection("shops");

    map<json> filter = {"shopId": newShop.shopId};
    mongodb:FindOptions findOptions = {};

    Shop? existingShop = check shopsCollection->findOne(filter, findOptions, (), Shop);

    if existingShop is () {
        check shopsCollection->insertOne(newShop);
    } else {
        io:print("Shop with shopId " + newShop.shopId + " already exists.");
    }
}

// Insert multiple shops
public isolated function insertMultipleShops(mongodb:Database ecommerceDb, Shop[] newShops) returns error? {
    mongodb:Collection shopsCollection = check ecommerceDb->getCollection("shops");
    check shopsCollection->insertMany(newShops);
}

// Update an existing shop by shopId
public isolated function updateShop(mongodb:Database ecommerceDb, string shopId, map<json> updates) returns error? {
    mongodb:Collection shopsCollection = check ecommerceDb->getCollection("shops");

    map<json> query = {"shopId": shopId};
    mongodb:Update updateData = {"set": updates};

    anydata updateResult = check shopsCollection->updateOne(query, updateData);
}
