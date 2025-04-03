import ballerina/http;
import ballerinax/ai.agent;

listener agent:Listener ai_chatListener = new (listenOn = check http:getDefaultListener());

service /ai_chat on ai_chatListener {
    resource function post chat(@http:Payload agent:ChatReqMessage request) returns agent:ChatRespMessage|error {

        string stringResult = check _ai_chatAgent->run(request.message);
        return {message: stringResult};
    }
}
