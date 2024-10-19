import ballerina/grpc;
import ballerina/protobuf;

public const string SEARCH_SERVICE_DESC = "0A147365617263685F736572766963652E70726F746F22390A0C51756572795265717565737412140A0571756572791801200128095205717565727912130A05746F705F6B1802200128055204746F704B222B0A0E536561726368526573706F6E736512190A086974656D5F69647318012003280952076974656D49647332400A0D53656172636853657276696365122F0A0D506572666F726D536561726368120D2E5175657279526571756573741A0F2E536561726368526573706F6E7365620670726F746F33";

public isolated client class SearchServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SEARCH_SERVICE_DESC);
    }

    isolated remote function PerformSearch(QueryRequest|ContextQueryRequest req) returns SearchResponse|grpc:Error {
        map<string|string[]> headers = {};
        QueryRequest message;
        if req is ContextQueryRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SearchService/PerformSearch", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchResponse>result;
    }

    isolated remote function PerformSearchContext(QueryRequest|ContextQueryRequest req) returns ContextSearchResponse|grpc:Error {
        map<string|string[]> headers = {};
        QueryRequest message;
        if req is ContextQueryRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SearchService/PerformSearch", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchResponse>result, headers: respHeaders};
    }
}

public type ContextQueryRequest record {|
    QueryRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchResponse record {|
    SearchResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SEARCH_SERVICE_DESC}
public type QueryRequest record {|
    string query = "";
    int top_k = 0;
|};

@protobuf:Descriptor {value: SEARCH_SERVICE_DESC}
public type SearchResponse record {|
    string[] item_ids = [];
|};

