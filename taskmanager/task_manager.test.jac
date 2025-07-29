test test_create {
    root spawn CreateTask(
        name = "Complete project report",
        description = "Finalize and submit the project report by end of the week.",
        dueDate = 8,
        priority = 1,
        assignedTo = "user123"
    );
    check [root --> (`?Task)];
}

test test_check {
    check_walker = root spawn CheckSchedule(date = 8);
    check check_walker.task;
}