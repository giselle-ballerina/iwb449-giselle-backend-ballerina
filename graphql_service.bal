import test2.rest;

import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

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

    // GraphQL query to get a single user by userId
    resource function get user(string userId) returns rest:User|error {
        return rest:getOneUser(self.ecommerceDb, userId);
    }
}
