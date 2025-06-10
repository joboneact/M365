// Author: Microsoft
// Date: 2023-10-01
// Platform: Microsoft Power Query M
// Description: This code snippet demonstrates how to find a user based on a Planner ID from a task in Microsoft Planner.


// This Power Query M code snippet demonstrates how to find a user based on a Planner ID from a task in Microsoft Planner.
// Power Query M code to find a user based on a Planner ID from a task in Microsoft Planner
// This code assumes you have two tables: Users and PlannerTasks

// Example Power Query M code
let
    // Replace with your actual data sources
    Users = Excel.CurrentWorkbook(){[Name="Users"]}[Content],
    PlannerTasks = Excel.CurrentWorkbook(){[Name="PlannerTasks"]}[Content],

    // Replace "PlannerIdToFind" with the actual Planner ID you want to look up
    PlannerIdToFind = "YOUR_PLANNER_ID",

    // Find the task with the given Planner ID
    TaskRow = Table.SelectRows(PlannerTasks, each [PlannerId] = PlannerIdToFind),

    // Get the User ID from the task
    UserId = if Table.IsEmpty(TaskRow) then null else TaskRow{0}[UserId],

    // Look up the user details
    UserRow = Table.SelectRows(Users, each [UserId] = UserId)
in
    UserRow