extends GutTest

class TestSomeAspects:
    extends GutTest

    func test_assert_eq_number_not_equal():
        pass
        # assert_eq(1, 2, "Should fail.  1 != 2")

    func test_assert_eq_number_equal():
        assert_eq('asdf', 'asdf', "Should pass")

class TestOtherAspects:
    extends GutTest

    func test_assert_true_with_true():
        assert_true(true, "Should pass, true is true")
