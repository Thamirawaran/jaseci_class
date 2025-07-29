# Not currently working
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

walker TaskManager {
    has question: str;

    obj __specs__ {
        static has auth: bool = False;
    }
    
    def select_tool(question: str) -> Callable by llm(tools= [
        create_task,
        self.summarise_task
    ]);

    can execute with `root entry {
        tool = self.select_tool(self.question);
        report tool();
    }

    def summarise_task(query: str) {
        tasks = [root --> (`?Task)];
        return summarise(query, tasks);
    }
}

