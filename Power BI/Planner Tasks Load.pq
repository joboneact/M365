let
    // Load Planner JSON data from a file (update the path as needed)
    Source = Json.Document(File.Contents("c:\Davis\Projects\M365\Power BI\SamplePlanner.json")),

    // Convert the list of tasks to a table
    TasksTable = Table.FromList(Source, Splitter.SplitByNothing(), {"Task"}, null, ExtraValues.Error),
    ExpandedTasks = Table.ExpandRecordColumn(
        TasksTable,
        "Task",
        {"id", "title", "assignedTo", "dueDate", "bucketId"}
    ),

    // Expand the assignedTo array to get user details for each task
    ExpandedAssignedTo = Table.ExpandListColumn(ExpandedTasks, "assignedTo"),
    ExpandedUser = Table.ExpandRecordColumn(
        ExpandedAssignedTo,
        "assignedTo",
        {"userId", "displayName", "email"}
    )
in
    ExpandedUser