import ballerina/http;
import ballerinax/redis;
import ballerina/log;

type Greeting record {
    string 'from;
    string to;
    string message;
};

redis:ConnectionConfig redisConfig = {
    host: "127.0.0.1:6379",
    password: "",
    options: { connectionPooling: true, isClusterConnection: false, ssl: false,
        startTls: true, verifyPeer: true }
};
redis:Client conn = check new (redisConfig);


service / on new http:Listener(9090) {
    
    resource  function get greet(string name) returns Greeting|error {


    var setResult = conn->set("tt", "Ballerina");

    if (setResult is string) {
        log:printInfo("String value inserted" + setResult);    // setResult is "OK"
    } else {
       log:printInfo("Error while set");
        log:printInfo(setResult.toString());
    }

    var getResult = conn->get("tt");
    if (getResult is string) {
        log:printInfo(getResult);  // getResult is "Ballerina"
    } else if (getResult is ()) {
        log:printInfo("Key not found");
    } else {
        log:printInfo("Error while fetching");
        log:printInfo(getResult.toString());
    }

    conn.stop();
        Greeting greetingMessage = {"from" : "Choreo", "to" : name, "message" : "Welcome to Choreo!"};
        return greetingMessage;
    }
}
