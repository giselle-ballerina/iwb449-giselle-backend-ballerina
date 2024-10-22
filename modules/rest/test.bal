
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



// Retrieve all items
public isolated function getTests(mongodb:Database ecommerceDb) returns Test[]|error {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("tests");
    stream<Test, error?> result = check itemsCollection->find();
    return from Test t in result
        select t;
}


public isolated function insertTest(mongodb:Database ecommerceDb, Test newItem) returns error? {
    mongodb:Collection itemsCollection = check ecommerceDb->getCollection("tests");

   
        check itemsCollection->insertOne(newItem);

}
