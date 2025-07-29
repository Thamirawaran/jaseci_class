import from mtllm.llm {Model}


glob llm: Model = Model(model_name = "gemini/gemini-2.5-flash");

enum AgentType {
    CreateTaskAgent = "CreateTaskAgent",
    SummariseAgent = "SummariseAgent"
}

walker TaskManager {
    has question: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    def select_agent(question: str) -> AgentType by llm();

    can execute with `root entry {
        agent = self.select_agent(self.question);
        # print(type(agent));
        if agent == AgentType.CreateTaskAgent {
            root spawn CreateTaskAgent(description = self.question);
        } elif agent == AgentType.SummariseAgent {
            root spawn SummariseAgent(query = self.question);
        } else {
            report "No suitable agent found for the question.";
        }
    }
}

walker CreateTaskAgent {
    has description:str;

    obj __specs__ {
        static has auth: bool = False;
    }

    def get_task(description: str) -> Task by llm();

    can create_task with `root entry {
        task = self.get_task(self.description);
        report task;
    }
}

walker SummariseAgent {
    has query: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    def summarise(query: str, tasks: list[Task]) -> str by llm();

    can summarise_task with `root entry {
        tasks = [here --> (`?Task)];
        summary = self.summarise(self.query, tasks);
        report summary;
    }
}


node Task {
    has name:str;
    has description:str;
    has dueDate:int;
    has priority:int;
    has status:str; # e.g., "pending", "in-progress", "completed"
    has assignedTo:str; # user ID or name
}