
import ballerinax/mongodb;

public type Test record {|
    string itemId;
    string shopId;
    decimal price;
    string productName;
  
    string? description;
    string? brand;
      Tag[]? tags;
    
    Variente[]? varients;
    Image[]? images;
|};

public type Variente record {|
    string color;
    string size;
    int qty;
|};
// public type Tag record {|
//     string name;
// |};
// public type Image record {|
//     string url;
// |};


// Retrieve all items
public isolated function getTests(mongodb:Database ecommerceDb) returns Test[]|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("tests");
    stream<Test, error?> result = check itemsCollection->find();
    return from Test t in result
        select t;
}

// Retrieve a single item by itemId


// Retrieve all items by shopId


// Insert a new item
public isolated function insertTest(mongodb:Database ecommerceDb, Test newItem) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("tests");

   
        check itemsCollection->insertOne(newItem);

}
// curl -X POST http://localhost:9091/test \
// -H "Content-Type: application/json" \
// -d '{
//     "itemId": "item_001",
//     "shopId": "shop_001",
//     "price": 29.99,
//     "productName": "Blue T-Shirt",
//     "description": "A stylish blue t-shirt for casual wear.",
//     "brand": "BrandName",
//     "tags": [
//         {"name": "clothing"},
//         {"name": "t-shirt"}
//     ],
//     "varients": [
//         {"color": "blue", "size": "M", "qty": 10},
//         {"color": "blue", "size": "L", "qty": 15}
//     ],
//     "images": [
//         {"url": "https://example.com/images/tshirt1.jpg"},
//         {"url": "https://example.com/images/tshirt2.jpg"}
//     ]
// }'

