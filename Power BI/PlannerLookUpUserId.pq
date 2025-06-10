


// This code snippet is part of a larger M code file for Power BI.
// It demonstrates how to look up a user based on a Planner ID from a task in Microsoft Planner.
// The code assumes you have two tables: Users and PlannerTasks, and it filters the tasks to find the one with the specified Planner ID.
// It then retrieves the User ID from that task and looks up the user details in the Users table.
// The result is a table containing the user details associated with the specified Planner ID.
// The code is designed to be used in Power BI and is written in Power Query M language.
// The code snippet is part of a larger M code file for Power BI.
// This code snippet is part of a larger M code file for Power BI.
// It demonstrates how to look up a user based on a Planner ID from a task in Microsoft Planner.
// ...existing code...
// M code to look up Planner user ID from a task

let
    // Load the JSON file
    Source = Json.Document(File.Contents("SamplePlanner.json")),

    // Convert to table
    TasksTable = Table.FromList(Source, Splitter.SplitByNothing(), {"Task"}, null, ExtraValues.Error),
    ExpandedTasks = Table.ExpandRecordColumn(TasksTable, "Task", {"id", "title", "assignedTo", "dueDate", "bucketId"}),

    // Set the task ID you want to look up
    TaskIdToFind = "task-002",

    // Filter for the specific task
    TaskRow = Table.SelectRows(ExpandedTasks, each [id] = TaskIdToFind),

    // Expand the assignedTo array to get user info
    AssignedUsers = Table.ExpandListColumn(TaskRow, "assignedTo"),
    UserInfo = Table.ExpandRecordColumn(AssignedUsers, "assignedTo", {"userId", "displayName", "email"}),

    // Select only the userId column (or any user info you need)
    UserIds = UserInfo[userId]
in
    UserIds
// ...existing code...


// put code info a function

// ...existing code...

// Function to look up user IDs assigned to a Planner task by task ID
let
    LookupPlannerUserIds = (TaskId as text, OptionalFilePath as nullable text) as list =>
    let
        // Use provided file path or default to "SamplePlanner.json"
        FilePath = if OptionalFilePath <> null then OptionalFilePath else "SamplePlanner.json",
        Source = Json.Document(File.Contents(FilePath)),
        TasksTable = Table.FromList(Source, Splitter.SplitByNothing(), {"Task"}, null, ExtraValues.Error),
        ExpandedTasks = Table.ExpandRecordColumn(TasksTable, "Task", {"id", "title", "assignedTo", "dueDate", "bucketId"}),
        TaskRow = Table.SelectRows(ExpandedTasks, each [id] = TaskId),
        AssignedUsers = Table.ExpandListColumn(TaskRow, "assignedTo"),
        UserInfo = Table.ExpandRecordColumn(AssignedUsers, "assignedTo", {"userId", "displayName", "email"}),
        UserIds = UserInfo[userId]
    in
        UserIds
in
    LookupPlannerUserIds
// ...existing code...
