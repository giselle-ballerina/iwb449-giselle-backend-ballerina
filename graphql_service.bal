import test2.rest;

import ballerina/graphql;
import ballerina/http;
import ballerina/io;
import ballerina/jwt;
import ballerinax/mongodb;

// Define the JWT Auth Config
jwt:ValidatorConfig validatorConfig = {
    issuer: "https://dev-i3yw6d5usqkkasb3.us.auth0.com", // Auth0 domain
    audience: "g8abCZJziIXX2yr5eSJtuNJ5Ogrc9LL7", // Set this to your Auth0 Client ID or specified audience
    signatureConfig: {
        jwksConfig: {url: "https://dev-i3yw6d5usqkkasb3.us.auth0.com/.well-known/jwks.json"}, // JWKS endpoint for public keys
        secret: "75c897781205c4b56e7b606741e8df3cce6bcda53734b38bc7694615ef7e0c78" // HMAC secret if applicable
    }
};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*", "http://localhost:3000/"],
        allowCredentials: true,
        allowHeaders: ["Authorization", "Content-Type"],
        allowMethods: ["GET", "POST", "OPTIONS", "PUT", "DELETE"],
        maxAge: 84900
    }
}

service / on new graphql:Listener(9090) {

    private final mongodb:Database ecommerceDb;

    function init() returns error? {
        self.ecommerceDb = check mongoDb->getDatabase("ecommerce");
        io:println("graphql server running on port 9090");
        return;
    }

    // GraphQL query to get all users
    resource function get users() returns rest:User[]|error {

        return rest:getUsers(self.ecommerceDb);
    }

    // // GraphQL query to get a single user by userId
    // resource function get user(string userId, @http:Header string token)

    resource function get user(string userId)
            returns rest:User|error {
        // // Validate the JWT token
        // io:println("hi");
        // io:println("Token: " + token);
        // check self.validateJwt(token);
        return rest:getOneUser(self.ecommerceDb, userId);
    }

    resource function get shops() returns rest:Shop[]|error {
        return rest:getShops(self.ecommerceDb);
    }

    // GraphQL query to get a single shop by shopId
    resource function get shop(string shopId) returns rest:Shop|error {
        return rest:getOneShop(self.ecommerceDb, shopId);
    }

    // GraphQL query to get shops by userId
    resource function get shopByUser(string userId) returns rest:Shop|error {
        // Retrieve shops associated with the specified userId
        return rest:getOneShopByUser(self.ecommerceDb, userId);
    }

    function validateJwt(string token) returns error? {
        // The token usually comes with a "Bearer " prefix, remove it before validation
        string jwt;
        if token.startsWith("Bearer ") {
            jwt = token.substring(7); // Remove the 'Bearer ' prefix
        } else {
            jwt = token;
        }
        // Validate the token
        jwt:Payload|error result = check jwt:validate(jwt, validatorConfig);
        if result is error {
            io:println("Invalid JWT token");
            return error("Unauthorized");
        }
        io:println("JWT Token valid");
        return;
    }
}
