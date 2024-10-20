// import ballerinax/kafka;
// import ballerina/log;
// import ballerina/io;
// kafka:ConsumerConfiguration consumerConfiguration = {
//     groupId: "group-id",
//     topics: ["kafka-topic-1"],
//     pollingInterval: 1,
//     autoCommit: false
// };

// listener kafka:Listener kafkaListener = new (kafka:DEFAULT_URL, consumerConfiguration);

// service on kafkaListener {
//     function onInit() {
//         log:printInfo("Kafka listener started, waiting for messages...");
//     }

//     remote function onConsumerRecord(kafka:Caller caller, kafka:BytesConsumerRecord[] records) {
//         io:println("Received messages: ", records);
//         kafka:Error? commitResult = caller->commit();

//         if commitResult is kafka:Error {
//             log:printError("Error occurred while committing the offsets for the consumer ", 'error = commitResult);
//         }else{
//             log:printInfo("Successfully committed the offsets for the consumer");
//         }
//     }
// }
