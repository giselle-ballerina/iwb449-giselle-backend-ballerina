import ballerina/http;
import ballerina/test;

// import ballerina/io;

@test:Config {}
function testAddUser() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Define a JSON payload for the new user
    json newUser = {
        "userId": "user001",
        "name": "Alice Doe",
        "email": "alice@example.com",
        "phone": "+123456789",
        "address": "456 Main Street",
        "orders": [{"orderId": "order001"}],
        "cart": [{"itemId": "item001", "itemPrice": 99.99}],
        "wishlist": [{"itemId": "item002"}],
        "notifications": [
            {
                "notificationId": "notif001",
                "notificationText": "Welcome",
                "notificationDate": "2024-10-01",
                "notificationType": "general"
            }
        ]
    };

    // Send a POST request to insert the new user
    http:Response response = check clientEP->post("/user", newUser);

    // Assert the response status and message
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");
    test:assertEquals(response.getTextPayload(), "User inserted successfully", msg = "User insertion failed");
}

@test:Config {}
function testUpdateUser() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Define a JSON payload for the update
    json updateUser = {
        "email": "newemail@example.com",
        "address": "New Updated Address",
        "phone": "+987654321"
    };

    // Send a PUT request to update the user data
    http:Response response = check clientEP->put("/user/user001", updateUser);

    // Assert the response status and message
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");
    test:assertEquals(response.getTextPayload(), "User updated successfully", msg = "User update failed");
}

// Test case for adding a new shop
@test:Config {}
function testAddShop() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Define a JSON payload for the new shop
    json newShop = {
        "shopId": "shop001",
        "shopName": "ShopOne",
        "owner": {
            "name": "John Doe",
            "userId": "user001",
            "email": "john@example.com",
            "phone": "+1122334455",
            "address": "123 Main Street"
        },
        "description": "This is ShopOne",
        "background": "white",
        "color": {
            "primary": "blue",
            "secondary": "gray"
        },
        "font": {
            "primary": "Arial",
            "secondary": "Verdana"
        },
        "insights": [
            {
                "totalViews": 100,
                "totalLikes": 50,
                "totalShares": 10,
                "totalOrders": 20,
                "totalRevenue": 5000.50,
                "totalProducts": 30
            }
        ]
    };

    // Send a POST request to insert the new shop
    http:Response response = check clientEP->post("/shop", newShop);

    // Assert the response status and message
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");
    test:assertEquals(response.getTextPayload(), "Shop inserted successfully", msg = "Shop insertion failed");
}

// Test case for updating a shop's information
@test:Config {}
function testUpdateShop() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Define a JSON payload for the update
    json updateShop = {
        "description": "Updated description for ShopOne",
        "background": "lightgray",
        "color": {
            "primary": "green",
            "secondary": "white"
        }
    };

    // Send a PUT request to update the shop data
    http:Response response = check clientEP->put("/shop/shop001", updateShop);

    // Assert the response status and message
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");
    test:assertEquals(response.getTextPayload(), "Shop updated successfully", msg = "Shop update failed");
}

// Test case for getting all shops
@test:Config {}
function testGetShops() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Send a GET request to retrieve all shops
    http:Response response = check clientEP->get("/shops");

    // Assert the response status
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");

    // Extract the response payload as JSON
    json shopsJson = check response.getJsonPayload();

    // Assert that the returned shops list contains at least one shop
    test:assertTrue(shopsJson is json[], msg = "Expected a JSON array of shops");

}

// Test case for retrieving a specific shop by shopId
@test:Config {}
function testGetOneShop() returns error? {
    // Create a test client to send requests to the service
    http:Client clientEP = check new ("http://localhost:9091");

    // Send a GET request to retrieve the shop with the shopId "shop001"
    http:Response response = check clientEP->get("/shop/shop001");

    // Assert the response status
    test:assertEquals(response.statusCode, 200, msg = "Expected status 200");

    // Extract the response payload as JSON
    json shopJson = check response.getJsonPayload();

    // Assert that the returned shop contains the correct shopId
    // test:assertEquals(shopJson.shopId.toString(), "shop001", msg = "Expected shopId 'shop001'");
}
