/// DAY 2: Primitive Types & Simple Functions

module challenge::day_02 {

    use std::unit_test::assert_eq;

    /// Takes two u64 numbers and returns their sum
    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    #[test]
    fun test_sum() {
        let result = sum(1, 2);
        assert_eq!(result, 3);
    }
}