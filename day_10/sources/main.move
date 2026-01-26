module challenge::day_10 {

    use std::string::String;

    /// Task status enum
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    /// Task struct
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    /// Create a new task (public API)
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    /// Check if task is open
    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }

    /// ✅ DAY 10 GOAL:
    /// Public function to complete a task
    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    // ---------------- TEST ----------------

    #[test]
    fun test_complete_task() {
        let mut task = new_task(b"Learn Move".to_string(), 100);

        assert!(is_open(&task));

        complete_task(&mut task);

        assert!(task.status == TaskStatus::Completed);
    }
}
