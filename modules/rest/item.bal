import ballerina/io;
import ballerinax/mongodb;

public type Item record {|
    string itemId;
    string shopId;
    decimal price;
    string[] tags;
    string productName;
    Varient[]? varients;
    string? description;
    string? brand;
|};

public type Varient record {|
    string color;
    string size;
    int qty;
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

public isolated function insertItem(mongodb:Database ecommerceDb, Item newItem) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("items");

    // Query to check if an item with the given itemId already exists
    io:print("newItem.itemId: " + newItem.itemId);
    // check itemsCollection->insertOne(newItem);
    map<json> filter = {"itemId": newItem.itemId};

    // Create an empty FindOptions object, as required by the findOne function
    mongodb:FindOptions findOptions = {};

    // Check if the item exists in the database
    Item? existingItem = check itemsCollection->findOne(filter, findOptions, (), Item);

    if existingItem is () {
        // Item does not exist, proceed with inserting the new item
        check itemsCollection->insertOne(newItem);
    } else {
        // Handle the case where the item already exists
        io:print("Item with itemId " + newItem.itemId + " already exists.");
    }
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
