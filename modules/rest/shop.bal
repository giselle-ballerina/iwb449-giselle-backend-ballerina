import ballerinax/mongodb;

public type Shop record {|
    string shopId;
    string shopName;
    Owner owner;
    string? description;
    string? background;
    Color? color;
    string? logo;
    Font? font;
    Insight[]? insights;
|};

public type Owner record {|
    string name;
    string email;
    string? phone;
    string? address;
|};

public type Color record {|
    string primary;
    string secondary;
|};

public type Font record {|
    string primary;
    string secondary;
|};

public type Insight record {|
    int totalViews;
    int totalLikes;
    int totalShares;
    int totalOrders;
    decimal totalRevenue;
    int totalProducts;
|};

public isolated function getShops(mongodb:Database ecommerceDb) returns Shop[]|error {
    mongodb:Collection shops = check ecommerceDb->getCollection("shops");
    stream<Shop, error?> result = check shops->find();
    return from Shop s in result
        select s;
}
