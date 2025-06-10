
create sample json that microosft planner would emit. create a few tasks and add random users and show the json.

// SamplePlanner.json
// This JSON file contains a sample structure for a Microsoft Planner plan.

// Here is a sample JSON payload similar to what Microsoft Planner might emit for a set of tasks, each assigned to random users. This example includes a few tasks and user assignments:


This structure includes:

id: Unique task ID
title: Task name
assignedTo: Array of user objects (with userId, displayName, email)
dueDate: Due date in ISO 8601 format
bucketId: The bucket/group the task belongs to


You can expand or modify this structure to match your needs or the actual Microsoft Graph API schema.






how to add json comments


JSON does not officially support comments. Any text outside the valid JSON structure (such as  or /* ... */) will cause most JSON parsers to fail.

Workarounds:

You can add a property like "__comment" or "_note" to hold comment text, but this is not standard and should be removed before using the JSON with systems that expect strict JSON.
Example:

Note:
Lines like // SamplePlanner.json or // This JSON file... at the end of your file are not valid in strict JSON and should be removed for compatibility.


