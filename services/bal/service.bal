import ballerina/http;
import ballerina/log;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        log:printInfo("Received greeting for name: " + name);
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    resource function get greetingJson(string name) returns json|error {
        // Send a response back to the caller.
        log:printInfo("Received greeting for name: " + name);
        if name is "" {
            return error("name should not be empty!");
        }
        json jsonContent = {"name": name};
        ///

        return jsonContent;
    }

    resource function get user/profile() returns json|error {
        // Send a response back to the caller.
        log:printInfo("Calling user/profile");

        json jsonContent = {"name": "Bob","email":"bob@gmail.com","id":"123"};

        return jsonContent;
    }
}
// comment: 15
