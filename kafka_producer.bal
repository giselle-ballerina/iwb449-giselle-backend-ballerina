// import ballerinax/kafka;
// import ballerina/io;
// public function main() returns error? {
//     kafka:ProducerConfiguration producerConfiguration = {
//         clientId: "basic-producer",
//         acks: "all",
//         retryCount: 3
//     };

//     kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, producerConfiguration);

//     string message = "Hello, World!";

//     check kafkaProducer->send({
//         topic: "kafka-topic-1",
//         key: "1",
//         value: message
//     });
    
//     io:println("Message sent successfully: " + message);


// }