/// DAY 9: Enums & TaskStatus

module challenge::day_09 {
    use std::string::String;

    /// Enum: TaskStatus
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    /// Task struct (done: bool yerine status: TaskStatus)
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    /// Constructor: yeni task Open başlar
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    /// task açık mı?
    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }
}
