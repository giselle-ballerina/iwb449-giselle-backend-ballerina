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

// Retrieve a single offer by offerId
public isolated function getOneOffer(mongodb:Database ecommerceDb, string offerId) returns Offer|error {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");
    map<json> filter = {"offerId": offerId};
    mongodb:FindOptions findOptions = {};
    Offer? foundOffer = check offersCollection->findOne(filter, findOptions, (), Offer);
    if foundOffer is () {
        return error("Offer with offerId '" + offerId + "' not found.");
    } else {
        return foundOffer;
    }
}
//get offers by shop id
public isolated function getOneOfferShop(mongodb:Database ecommerceDb, string shopId) returns Offer[]|error {
    // Log the process for debugging
    io:print("Fetching offers for shopId: ", shopId);    
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");
    map<json> filter = {"shopId": shopId};
    mongodb:FindOptions findOptions = {};
    stream<Offer, error?> offerStream = check offersCollection->find(filter, findOptions, (), Offer);
    Offer[] offers = [];
    check from var offer in offerStream
        do {
            offers.push(offer);
    };
    io:print(offers, " offers found ");
    if offers.length() == 0 {
        return error("No offers found for the shopId: " + shopId);
    }
    return offers;
}

public isolated function insertOffer(mongodb:Database ecommerceDb, Offer newOffer) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");
    map<json> filter = {"offerId": newOffer.offerId};
    mongodb:FindOptions findOptions = {};
    Offer? existingOffer = check offersCollection->findOne(filter, findOptions, (), Offer);
    if existingOffer is () {
        check offersCollection->insertOne(newOffer);
    } else {
        io:print("Offer with offerId " + newOffer.offerId + " already exists.");
    }
}
//insert multiple offers
public isolated function insertMultipleOffers(mongodb:Database ecommerceDb, Offer[] newOffers) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");
    check offersCollection->insertMany(newOffers);
}

public isolated function updateOffer(mongodb:Database ecommerceDb, string offerId, map<json> updates) returns error? {
    mongodb:Collection offersCollection = check ecommerceDb->getCollection("offers");
    map<json> query = {"offerId": offerId};
    mongodb:Update updateData = {"set": updates};
    anydata updateResult = check offersCollection->updateOne(query, updateData);
}

