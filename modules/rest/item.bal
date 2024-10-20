
import ballerinax/mongodb;
import ballerina/io;
public type Item record {|
    string itemId;
    string shopId;
    decimal price;
    string productName;
  
    string? description;
    string? brand;
      Tag[]? tags;
    
    Varient[]? varients;
    Image[]? images;
|};

public type Varient record {|
    string color;
    string size;
    int qty;
|};
public type Tag record {|
    string name;
|};
public type Image record {|
    string url;
|};

public isolated function getItems(mongodb:Database ecommerceDb) returns Item[]|error {
    mongodb:Collection items = check ecommerceDb->getCollection("items");
    stream<Item, error?> result = check items->find();
    return from Item i in result
        select i;
}

//get Item by id
public isolated function getOneItem(mongodb:Database ecommerceDb, string itemId) returns Item|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    map<json> filter = {"itemId": itemId};
    mongodb:FindOptions findOptions = {};
    Item? foundItem = check itemsCollection->findOne(filter, findOptions, (), Item);
    if foundItem is () {
        return error("Item with itemId '" + itemId + "' not found.");
    } else {
        return foundItem;
    }
}

//get items by shop id
public isolated function getItemsByShop(mongodb:Database ecommerceDb, string shopId) returns Item[]|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};
    stream<Item, error?> foundItemsStream = check itemsCollection->find(filter, findOptions, (), Item);
    Item[] foundItems = [];
    while true {
        var result = foundItemsStream.next();
        if result is record {| Item value; |} {
            foundItems.push(result.value);
        } else if result is error {
            return result;
        } else {
            break;
        }
    }
    check foundItemsStream.close();
    if foundItems.length() == 0 {
        return error("No items found for shopId '" + shopId + "'");
    }
    return foundItems;
}

//filter items by shop
public isolated function filterItemsbyShop(mongodb:Database ecommerceDb, string shopId )returns Item[]|error{
    io:print("in item folder");
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};
    stream<Item, error?> itemStream = check itemsCollection->find(filter, findOptions, (), Item);
    Item[] items = [];
    check from var item in itemStream
        do {
            items.push(item);
    };
    io:print(items, "items here ");
    if items.length() == 0 {
        return error("No items found for the shopId: " + shopId);
    }
    return items;

}
public isolated function getRecommendedItems(mongodb:Database ecommerceDb, string[] itemIds) returns Item[]|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    Item[] foundItems = [];

    foreach string itemId in itemIds {
        map<json> filter = {"itemId": itemId};
        mongodb:FindOptions findOptions = {};

        Item? foundItem = check itemsCollection->findOne(filter, findOptions, (), Item);

        if foundItem is () {
            io:println("Item with itemId '" + itemId + "' not found.");
        } else {
            foundItems.push(foundItem);
        }
    }
    if foundItems.length() == 0 {
        return error("No items found for the given itemIds.");
    }
    return foundItems;
}

//filter items by price range
public isolated function filterItemsbyPrice1(mongodb:Database ecommerceDb, decimal priceLowerBound, decimal priceUpperBound)returns Item[]|error{
    io:print("in item folder");
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    map<json> filter = {"price": {"$gte": priceLowerBound, "$lte": priceUpperBound}};
    mongodb:FindOptions findOptions = {};
    stream<Item, error?> itemStream = check itemsCollection->find(filter, findOptions, (), Item);
    Item[] items = [];
    
    check from var item in itemStream
        do {
            items.push(item);
    };
    io:print(items, "items here ");
    if items.length() == 0 {
        return error("No items found for the price range");
    }
    return items;
}

//filter items by price upper bound
public isolated function filterItemsbyPrice2(mongodb:Database ecommerceDb, decimal priceUpperBound)returns Item[]|error{
    io:print("in item folder");
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    map<json> filter = {"price": {"$lte": priceUpperBound}};
    mongodb:FindOptions findOptions = {};
    stream<Item, error?> itemStream = check itemsCollection->find(filter, findOptions, (), Item);
    Item[] items = [];
    
    check from var item in itemStream
        do {
            items.push(item);
    };
    io:print(items, "items here ");
    if items.length() == 0 {
        return error("No items found for the price range");
    }
    return items;
}



public isolated function insertItem(mongodb:Database ecommerceDb, Item newItem) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    io:print(newItem);
    
    check itemsCollection->insertOne(newItem);
   
}

public isolated function insertMultipleItems(mongodb:Database ecommerceDb, Item[] newItems) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    check itemsCollection->insertMany(newItems);
}

public isolated function updateItem(mongodb:Database ecommerceDb, string itemId, map<json> updates) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    map<json> query = {"itemId": itemId};

    mongodb:Update updateData = {"set": updates};

    anydata updateResult = check itemsCollection->updateOne(query, updateData);
}
