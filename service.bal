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


    var setResult = conn->set(name, name+"Ballerina");
    Greeting greetingMessage;

    if (setResult is string) {
        log:printInfo("String value inserted" + setResult);
       
    } else {
       log:printInfo("Error while set");
       log:printInfo(setResult.toString());
    }

    var getResult = conn->get(name);
    if (getResult is string) {
        log:printInfo(getResult);  // getResult is "Ballerina"
         greetingMessage = {"from" : "Choreo", "to" : name, "message" : getResult.toString()};    // setResult is "OK"
    } else if (getResult is ()) {
        log:printInfo("Key not found");
          greetingMessage = {"from" : "Choreo", "to" : name, "message" : " "};   
    } else {
        log:printInfo("Error while fetching");
        log:printInfo(getResult.toString());  greetingMessage = {"from" : "Choreo", "to" : name, "message" : getResult.toString()};   
    }

       
        return greetingMessage;
    }
}
