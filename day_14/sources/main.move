module challenge::day_14 {
    use std::vector;
    use std::string::{Self, String};
    use std::option::{Self, Option};

    // test macro import (bazı sürümlerde gerekli)
    #[test_only]
    use std::unit_test::assert_eq;

    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun find_task_by_title(board: &TaskBoard, title: &String): Option<u64> {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            if (&t.title == title) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let mut total = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);
        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            total = total + t.reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let mut count = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);
        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            if (t.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    #[test]
    fun test_create_board_and_add_task() {
        let owner = @0x2;
        let mut board = new_board(owner);

        let task = new_task(string::utf8(b"Task"), 10);
        add_task(&mut board, task);

        assert_eq!(vector::length(&board.tasks), 1);
        let t_ref = vector::borrow(&board.tasks, 0);
        assert_eq!(t_ref.reward, 10);
    }

    #[test]
    fun test_complete_task() {
        let owner = @0x2;
        let mut board = new_board(owner);

        add_task(&mut board, new_task(string::utf8(b"A"), 5));
        let t_mut = vector::borrow_mut(&mut board.tasks, 0);
        complete_task(t_mut);

        assert_eq!(completed_count(&board), 1);
    }

    #[test]
    fun test_total_reward_and_find() {
        let owner = @0x2;
        let mut board = new_board(owner);

        add_task(&mut board, new_task(string::utf8(b"A"), 100));
        add_task(&mut board, new_task(string::utf8(b"B"), 300));

        assert_eq!(total_reward(&board), 400);

        let idx = find_task_by_title(&board, &string::utf8(b"B"));
        // Option<u64> kontrolü:
        assert_eq!(idx, option::some(1));
    }
}
