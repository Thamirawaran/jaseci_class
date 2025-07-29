import from mtllm.llm {Model}


glob llm: Model = Model(model_name = "gemini/gemini-2.5-flash");

def summarise(query: str, tasks: list[Task]) -> str by llm();

def create_task(description: str) -> Task by llm();

node Task {
    has name:str;
    has description:str;
    has dueDate:int;
    has status:str; # e.g., "pending", "in-progress", "completed"
    has assignedTo:str; # user ID or name
}

enum AgentType {
    CreateTaskTool = "CreateTaskTool",
    SummariseTool = "SummariseTool",
}

walker TaskManager {
    has question: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    def select_agent(question: str) -> AgentType by llm();

    can execute with `root entry {
        agent = self.select_agent(self.question);
        if agent == AgentType.CreateTaskTool {
            report root ++>create_task(description = self.question);
        } elif agent == AgentType.SummariseTool {
            report self.summarise_task(query = self.question);
        } else {
            report "No suitable agent found for the question.";
        }
    }

    def summarise_task(query: str) {
        tasks = [root --> (`?Task)];
        return summarise(query, tasks);
    }
}

