## NAME

`unit` - functions for unit testing.

## FUNCTIONS

* `unit::assert_yes VALUE [MESSAGE]`            - Show error message, when `VALUE` is not equal to `"yes"`.

* `unit::assert_no VALUE [MESSAGE]`             - Show error message, when `VALUE` is not equal to `"no"`.

* `unit::assert_not_empty VALUE [MESSAGE]`       - Show error message, when `VALUE` is empty.

* `unit::assert_equal ACTUAL EXPECTED [MESSAGE]`  - Show error message, when values are not equal.

* `unit::assert_arrays_are_equal MESSAGE VALUE1... -- VALUE2...` - Show error message when arrays are not equal in size or content.

* `unit::assert_not_equal ACTUAL_VALUE UNEXPECTED_VALUE [MESSAGE]` - Show error message, when values ARE equal.

* `unit::assert MESSAGE TEST[...]`             - Evaluate test and show error message when it returns non-zero exit code.

* `unit::fail [MESSAGE]`                       - Show error message.

* `unit::run_test_cases [OPTIONS] [--] [ARGUMENTS]` - Execute all functions with
   test* prefix in name in alphabetic order

   * OPTIONS:
     * `-t | --test TEST_CASE` - execute single test case,
     * `-q | --quiet`          - do not print informational messages and dots,
     * `--debug`               - enable stack traces.
  * ARGUMENTS - All arguments, which are passed to run_test_cases, are passed then
 to `unit::set_up`, `unit::tear_down` and test cases using `ARGUMENTS` array, so you
 can parametrize your test cases. You can call `run_test_cases` more than
 once with different arguments. Use `"--"` to strictly separate arguments
 from options.

 After execution of `run_test_cases`, following variables will have value:

   * `NUMBER_OF_TEST_CASES` - total number of test cases executed,
   * `NUMBER_OF_FAILED_TEST_CASES` - number of failed test cases,
   * `FAILED_TEST_CASES` - names of functions of failed tests cases.


 If you want to ignore some test case, just prefix them with
 underscore, so `unit::run_test_cases` will not see them.

 If you want to run few subsets of test cases in one file, define each
 subset in it own subshell and execute `unit::run_test_cases` in each subshell.

 Each test case is executed in it own subshell, so you can call `exit`
 in the test case or assign variables without any effect on subsequent test
 cases.

`unit::run_test_cases` will also call `unit::set_up` and `unit::tear_down`
functions before and after each test case. By default, they do nothing.
Override them to do something useful.

* `unit::set_up` - can set variables which are available for following
 test case and `tear_down`. It also can alter `ARGUMENTS` array. Test case
 and tear_down are executed in their own subshell, so they cannot change
 outer variables.

* `unit::tear_down` is called first, before first set_up of first test case, to
 cleanup after possible failed run of previous test case. When it
 called for first time, `FIRST_TEAR_DOWN` variable with value `"yes"` is
 available.

## NOTES

All assert functions are executing `exit` instead of returning error code.
