import ballerinax/ai.agent;

final agent:OpenAiModel _ai_chatModel = check new ("", "gpt-3.5-turbo-16k-0613");
final agent:Agent _ai_chatAgent = check new (systemPrompt = {
    role: "",
    instructions: string ``
}, model = _ai_chatModel, tools = []);
    