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
