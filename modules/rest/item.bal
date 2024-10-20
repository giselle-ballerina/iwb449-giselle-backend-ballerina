
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

public isolated function getOneItem(mongodb:Database ecommerceDb, string itemId) returns Item|error {
    // Get the "items" collection from the MongoDB database
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    // Define the filter query to find the item by "itemId"
    map<json> filter = {"itemId": itemId};

    // Define the options for the findOne operation
    mongodb:FindOptions findOptions = {};

    // Perform the findOne operation to get the single item
    Item? foundItem = check itemsCollection->findOne(filter, findOptions, (), Item);

    if foundItem is () {
        // Handle case where no item was found
        return error("Item with itemId '" + itemId + "' not found.");
    } else {
        // Return the found item
        return foundItem;
    }
}
public isolated function getItemsByShop(mongodb:Database ecommerceDb, string shopId) returns Item[]|error {
    // Get the "items" collection from the MongoDB database
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    // Define the filter query to find the items by "shopId"
    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};
    stream<Item, error?> foundItemsStream = check itemsCollection->find(filter, findOptions, (), Item);
    Item[] foundItems = [];

    // Iterate through the stream manually
    while true {
        var result = foundItemsStream.next();
        if result is record {| Item value; |} {
            // Add the item to the array
            foundItems.push(result.value);
        } else if result is error {
            // Handle any errors that occur while iterating
            return result;
        } else {
            // Stream has ended, break the loop
            break;
        }
    }

    // Close the stream after processing
    check foundItemsStream.close();

    // Check if no items were found
    if foundItems.length() == 0 {
        return error("No items found for shopId '" + shopId + "'");
    }

    // Return the array of found items
    return foundItems;
}

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
    // return from Item s in itemStream
    //     select s;
        
    // Check if no items were found
    if items.length() == 0 {
        return error("No items found for the shopId: " + shopId);
    }
    // Return the found items
    return items;

}
public isolated function getRecommendedItems(mongodb:Database ecommerceDb, string[] itemIds) returns Item[]|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    Item[] foundItems = [];

    foreach string itemId in itemIds {
        // Define the filter query to find the item by "itemId"
        map<json> filter = {"itemId": itemId};
        mongodb:FindOptions findOptions = {};

        // Perform the findOne operation to get the single item
        Item? foundItem = check itemsCollection->findOne(filter, findOptions, (), Item);

        if foundItem is () {
            io:println("Item with itemId '" + itemId + "' not found.");
        } else {
            // Add the found item to the result array
            foundItems.push(foundItem);
        }
    }

    // Check if no items were found
    if foundItems.length() == 0 {
        return error("No items found for the given itemIds.");
    }

    // Return the array of found items
    return foundItems;
}

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
    // Return the found items
    return items;
}

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
    // Return the found items
    return items;
}



public isolated function insertItem(mongodb:Database ecommerceDb, Item newItem) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");
    io:print(newItem);
    
    check itemsCollection->insertOne(newItem);
   
}

public isolated function insertMultipleItems(mongodb:Database ecommerceDb, Item[] newItems) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    // Insert multiple item documents into the collection
    check itemsCollection->insertMany(newItems);
}

public isolated function updateItem(mongodb:Database ecommerceDb, string itemId, map<json> updates) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    // Define the query to find the item by itemId
    map<json> query = {"itemId": itemId};

    // Define the update operation using the $set operator
    mongodb:Update updateData = {"set": updates};

    // Update the item's document
    anydata updateResult = check itemsCollection->updateOne(query, updateData);
}
