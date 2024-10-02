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

# Description.
#
# + ecommerceDb - parameter description
# + return - return value description
public isolated function getItems(mongodb:Database ecommerceDb) returns Item[]|error {
    mongodb:Collection items = check ecommerceDb->getCollection("items");
    stream<Item, error?> result = check items->find();
    return from Item i in result
        select i;
}
