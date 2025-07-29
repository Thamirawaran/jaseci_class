# Not currently working
import from mtllm.llm {Model}

glob llm: Model = Model(model_name = "gemini/gemini-2.5-flash");

def summarise_task(query: str, tasks: list[Task]) -> str by llm();

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
    
    def select_execute(question: str, tasks: list[Task]) -> Task | str by llm(tools= [
        create_task,
        summarise_task
    ]);

    can execute with `root entry {
        tasks = [root --> (`?Task)];
        report self.select_execute(self.question, tasks);
    }
}

