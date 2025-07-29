test test_create {
    root spawn TaskManager(
        question = "Create a task to complete the project report by 9th and assign to Thami."
    );
    check [root --> (`?Task)];
}

test test_check {
    root spawn TaskManager(
        question = "Summarise tasks due by 9th."
    );
}