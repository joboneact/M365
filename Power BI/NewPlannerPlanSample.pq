let
    SamplePlannerData = {
        [
            id = "task-001",
            title = "Prepare project kickoff",
            assignedTo = {
                [
                    userId = "user-100",
                    displayName = "Alice Johnson",
                    email = "alice.johnson@contoso.com"
                ]
            },
            dueDate = "2025-05-25T17:00:00Z",
            bucketId = "bucket-01"
        ],
        [
            id = "task-002",
            title = "Design wireframes",
            assignedTo = {
                [
                    userId = "user-101",
                    displayName = "Bob Smith",
                    email = "bob.smith@contoso.com"
                ],
                [
                    userId = "user-102",
                    displayName = "Carol Lee",
                    email = "carol.lee@contoso.com"
                ]
            },
            dueDate = "2025-05-28T17:00:00Z",
            bucketId = "bucket-02"
        ],
        [
            id = "task-003",
            title = "Review requirements",
            assignedTo = {
                [
                    userId = "user-103",
                    displayName = "David Kim",
                    email = "david.kim@contoso.com"
                ]
            },
            dueDate = "2025-05-30T17:00:00Z",
            bucketId = "bucket-01"
        ]
    }
in
    SamplePlannerData