module challenge::day_11 {

    use std::vector;
    use std::string::String;

    /// Task status
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    /// Single task
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    /// Create new task
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    /// Complete task
    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    /// Task board (ownership example)
    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    /// Create empty board
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    /// Add task to board
    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }
}
