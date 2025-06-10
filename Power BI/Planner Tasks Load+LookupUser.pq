// =====================================================================================================
// Power Query M Script: Planner Tasks Load + Lookup User
// -----------------------------------------------------------------------------------------------------
// HOW TO RUN THIS FILE:
// 1. Open Power BI Desktop or Excel Power Query.
// 2. Go to 'Home' > 'Transform data' to open the Power Query Editor.
// 3. Click 'Home' > 'Advanced Editor'.
// 4. Paste this code into the editor window.
// 5. Click 'Done' to apply and preview the results.
// 6. Use the output record fields (Tasks, Assignees, Buckets, LabelColors) as needed in your queries.
// -----------------------------------------------------------------------------------------------------
// This script loads Microsoft Planner JSON data, expands tasks and assignees, 
// and provides helper functions to extract unique assignees, buckets, and label colors.
// =====================================================================================================

let
    // Function: LoadAssignees
    // Extracts all unique assignees from the tasks table.
    // Input: tasksTable - table with a column [assignedTo] (list of assignee records)
    // Output: Table of unique assignees with userId, displayName, and email.
    LoadAssignees = (tasksTable as table) as table =>
        let
            // Combine all assignedTo lists into a single list
            AllAssignees = List.Combine(tasksTable[assignedTo]),
            // Convert the list to a table
            AssigneesTable = Table.FromList(AllAssignees, Splitter.SplitByNothing(), {"Assignee"}),
            // Expand the Assignee record to columns
            ExpandedAssignees = Table.ExpandRecordColumn(AssigneesTable, "Assignee", {"userId", "displayName", "email"}),
            // Remove duplicates
            UniqueAssignees = Table.Distinct(ExpandedAssignees)
        in
            UniqueAssignees,

    // Function: LoadBuckets
    // Extracts all unique bucket IDs from the tasks table.
    // Input: tasksTable - table with a column [bucketId]
    // Output: Table of unique bucket IDs.
    LoadBuckets = (tasksTable as table) as table =>
        Table.Distinct(Table.SelectColumns(tasksTable, {"bucketId"})),

    // Function: LoadLabelColors
    // Provides a static mapping of label names to colors.
    // Output: Table with columns [Label] and [Color].
    LoadLabelColors = () as table =>
        #table(
            {"Label", "Color"},
            {
                {"Urgent", "#e81123"},         // Red
                {"Client", "#0078d4"},         // Blue
                {"Internal", "#107c10"},       // Green
                {"Blocked", "#ffb900"},        // Yellow/Amber
                {"In Progress", "#605e5c"},    // Gray
                {"Review", "#b4009e"},         // Purple
                {"Documentation", "#00b294"},  // Teal
                {"Automation", "#8e562e"},     // Brown
                {"Follow Up", "#c239b3"}       // Magenta
            }
        ),

    // Load Planner JSON data from a file (update the path as needed)
    Source = Json.Document(File.Contents("Power BI\SamplePlanner.json")),

    // Convert the list of tasks (JSON array) to a table with a single column [Task]
    TasksTable = Table.FromList(Source, Splitter.SplitByNothing(), {"Task"}, null, ExtraValues.Error),

    // Expand the Task record to columns: id, title, assignedTo, dueDate, bucketId
    ExpandedTasks = Table.ExpandRecordColumn(
        TasksTable,
        "Task",
        {"id", "title", "assignedTo", "dueDate", "bucketId"}
    ),

    // Expand the assignedTo array so each row is a single user-task assignment
    ExpandedAssignedTo = Table.ExpandListColumn(ExpandedTasks, "assignedTo"),

    // Expand the assignedTo record to userId, displayName, and email columns
    ExpandedUser = Table.ExpandRecordColumn(
        ExpandedAssignedTo,
        "assignedTo",
        {"userId", "displayName", "email"}
    ),

    // Use the helper functions to get separate tables for assignees, buckets, and label colors
    AssigneesTable = LoadAssignees(ExpandedTasks),
    BucketsTable = LoadBuckets(ExpandedTasks),
    LabelColorsTable = LoadLabelColors()
in
    [
        // Main output: Each field is a table you can reference in Power BI
        Tasks = ExpandedUser,        // All tasks with user assignments expanded
        Assignees = AssigneesTable,  // Unique assignees
        Buckets = BucketsTable,      // Unique buckets
        LabelColors = LabelColorsTable // Label color mapping
    ]