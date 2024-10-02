
// Define the database variable

// Define the service
// Initialize data (uncomment and adapt as necessary)
// public function init() returns error? {
//     // Create collections
//     mongodb:Collection items = check ecommerceDb->getCollection("items");
//     mongodb:Collection shops = check ecommerceDb->getCollection("shops");
//     mongodb:Collection users = check ecommerceDb->getCollection("users");
//     mongodb:Collection purchases = check ecommerceDb->getCollection("purchases");
//     mongodb:Collection offers = check ecommerceDb->getCollection("offers");

//     // Insert sample data (commented out)
// }

// Define functions to fetch data from MongoDB

// public isolated function getShops(mongodb:Database ecommerceDb) returns Shop[]|error {
//     mongodb:Collection shops = check ecommerceDb->getCollection("shops");
//     stream<Shop, error?> result = check shops->find();
//     return from Shop s in result
//         select s;
// }

public function hello(string? name) returns string {
    if name !is () {
        return string `Hello, ${name}`;
    }
    return "Hello, World!";
}
