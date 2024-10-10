import ballerinax/mongodb;
import ballerina/io;


public type Offer record {|
    string offerId;
    string shopId;
    string offerText;
    string offerStartDate;
    string offerEndDate;
    decimal offerDiscount;
    string? offerCode;
    string? offerStatus;
    string? bannerImage;
|};

public isolated function getOffers(mongodb:Database ecommerceDb) returns Offer[]|error {
    mongodb:Collection offers = check ecommerceDb->getCollection("offers");
    stream<Offer, error?> result = check offers->find();
    return from Offer o in result
        select o;
}

public isolated function getOneOffer(mongodb:Database ecommerceDb, string offerId) returns Offer|error {
    // Get the "offers" collection from the MongoDB database
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");

    // Define the filter query to find the offer by "offerId"
    map<json> filter = {"offerId": offerId};

    // Define the options for the findOne operation
    mongodb:FindOptions findOptions = {};

    // Perform the findOne operation to get the single offer
    Offer? foundOffer = check offersCollection->findOne(filter, findOptions, (), Offer);

    if foundOffer is () {
        // Handle case where no offer was found
        return error("Offer with offerId '" + offerId + "' not found.");
    } else {
        // Return the found offer
        return foundOffer;
    }
}

public isolated function insertOffer(mongodb:Database ecommerceDb, Offer newOffer) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");

    // Query to check if an offer with the given offerId already exists
    map<json> filter = {"offerId": newOffer.offerId};

    // Create an empty FindOptions object, as required by the findOne function
    mongodb:FindOptions findOptions = {};

    // Check if the offer exists in the database
    Offer? existingOffer = check offersCollection->findOne(filter, findOptions, (), Offer);

    if existingOffer is () {
        // Offer does not exist, proceed with inserting the new offer
        check offersCollection->insertOne(newOffer);
    } else {
        // Handle the case where the offer already exists
        io:print("Offer with offerId " + newOffer.offerId + " already exists.");
    }
}

public isolated function insertMultipleOffers(mongodb:Database ecommerceDb, Offer[] newOffers) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");

    // Insert multiple offer documents into the collection
    check offersCollection->insertMany(newOffers);
}

public isolated function updateOffer(mongodb:Database ecommerceDb, string offerId, map<json> updates) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");

    // Define the query to find the offer by offerId
    map<json> query = {"offerId": offerId};

    // Define the update operation using the $set operator
    mongodb:Update updateData = {"set": updates};

    // Update the offer's document
    anydata updateResult = check offersCollection->updateOne(query, updateData);
}

