import ballerinax/mongodb;

public isolated function getOffers(mongodb:Database ecommerceDb) returns Offer[]|error {
    mongodb:Collection offers = check ecommerceDb->getCollection("offers");
    stream<Offer, error?> result = check offers->find();
    return from Offer o in result
        select o;
}

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
