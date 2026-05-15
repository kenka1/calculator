#include "litmath/math.hpp"

#include <errno.h>
#include <getopt.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

namespace
{
enum class Operations : uint8_t
{
    kAdd,
    kSub,
    kMul,
    kDiv,
    kPow,
    kFact,
    kUnknown
};

enum class TaskStatus : uint8_t
{
    kOk,
    kMathError,
    kHelp,
    kInvalidLaunch,
    kInvalidNumber,
    kUnsupportedOperation
};

struct Task
{
    int number1_{};
    int number2_{};
    Operations operation_{Operations::kUnknown};
    int result_{};
    TaskStatus status_{TaskStatus::kOk};
};

void makeTask(int argc, char** argv, Task& task);
void makeCalculate(Task& task);
void printResult(const Task& task);
void handleTaskStatus(TaskStatus status);

void applicationRun(int argc, char** argv)
{
    Task task{};

    makeTask(argc, argv, task);
    handleTaskStatus(task.status_);

    makeCalculate(task);
    handleTaskStatus(task.status_);

    printResult(task);
}

/*
 *  Convert string number to integer with error checking
 * */
lit::MathRes toInt(const char* number)
{
    if (!number || *number == '\0')
        return {0, lit::ErrorStatus::kInvalidNumber};
    char* endptr;
    errno = 0;
    const long res = strtol(number, &endptr, 10);
    if (endptr == number || *endptr != '\0' || errno == ERANGE ||
        res > INT_MAX || res < INT_MIN)
        return {0, lit::ErrorStatus::kInvalidNumber};
    return {static_cast<int>(res), lit::ErrorStatus::kOk};
}

/*
 *  Convert string operation to enum Operations
 * */
Operations toOperation(const char* operation)
{
    if (!operation)
        return Operations::kUnknown;
    if (strcmp(operation, "add") == 0)
        return Operations::kAdd;
    if (strcmp(operation, "sub") == 0)
        return Operations::kSub;
    if (strcmp(operation, "mul") == 0)
        return Operations::kMul;
    if (strcmp(operation, "div") == 0)
        return Operations::kDiv;
    if (strcmp(operation, "pow") == 0)
        return Operations::kPow;
    if (strcmp(operation, "fact") == 0)
        return Operations::kFact;
    return Operations::kUnknown;
}

/*
 * Parse number
 * return false and set status represent error if parse is failed
 * otherwise return true and set repeted and number
 * */
bool parseNumber(const char* str, int& number, bool& repeated,
                 TaskStatus& status)
{
    // Check repeated
    if (repeated)
    {
        status = TaskStatus::kInvalidLaunch;
        return false;
    }

    // Check number
    const auto res = toInt(str);
    if (res.error_ != lit::ErrorStatus::kOk)
    {
        status = TaskStatus::kInvalidNumber;
        return false;
    }

    number = res.value_;
    repeated = true;
    return true;
}

/*
 * Parse operation 
 * return false and set status represent error if parse is failed
 * otherwise return true and set repeted and operation
 * */
bool parseOperation(const char* str, Operations& operation, bool& repeated,
                    TaskStatus& status)
{
    // Check repeated
    if (repeated)
    {
        status = TaskStatus::kInvalidLaunch;
        return false;
    }

    // Check operation
    operation = toOperation(str);
    if (operation == Operations::kUnknown)
    {
        status = TaskStatus::kUnsupportedOperation;
        return false;
    }

    repeated = true;
    return true;
}

/*
 * Builds Task class based on parsing command-line arguments 
 * */
void makeTask(int argc, char** argv, Task& task)
{
    if (argc == 1)
    {
        task.status_ = TaskStatus::kInvalidLaunch;
        return;
    }

    static option long_options[] = {
        {"help", no_argument, nullptr, 'h'},
        {"first", required_argument, nullptr, 'f'},
        {"second", required_argument, nullptr, 's'},
        {"operation", required_argument, nullptr, 'o'},
        {nullptr, 0, nullptr, 0}};

    bool fFlag{false}, sFlag{false}, oFlag{false};
    int opt{};
    opterr = 0;
    while ((opt = getopt_long(argc, argv, "hf:s:o:", long_options, nullptr)) !=
           -1)
    {
        switch (opt)
        {
            case 'h':
                task.status_ = TaskStatus::kHelp;
                return;
            case 'f':
                if (!parseNumber(optarg, task.number1_, fFlag, task.status_))
                    return;
                break;
            case 's':
                if (!parseNumber(optarg, task.number2_, sFlag, task.status_))
                    return;
                break;
            case 'o':
                if (!parseOperation(optarg, task.operation_, oFlag,
                                    task.status_))
                    return;
                break;
            default:
                task.status_ = TaskStatus::kInvalidLaunch;
                return;
        }
    }

    const bool validBaseFlags = (optind == argc) && fFlag && oFlag;
    const bool isFact = (task.operation_ == Operations::kFact);
    // We dont have `--second` if operation is `fact`
    const bool validOperationFlags = isFact ? !sFlag : sFlag;

    if (!validBaseFlags || !validOperationFlags)
        task.status_ = TaskStatus::kInvalidLaunch;
}

/*
 * Base on task.operation perform calculation
 * */
void makeCalculate(Task& task)
{
    lit::MathRes res{};
    switch (task.operation_)
    {
        case Operations::kAdd:
            res = lit::add(task.number1_, task.number2_);
            break;
        case Operations::kSub:
            res = lit::subtract(task.number1_, task.number2_);
            break;
        case Operations::kMul:
            res = lit::multiply(task.number1_, task.number2_);
            break;
        case Operations::kDiv:
            res = lit::divide(task.number1_, task.number2_);
            break;
        case Operations::kPow:
            res = lit::pow(task.number1_, task.number2_);
            break;
        case Operations::kFact:
            res = lit::factorial(task.number1_);
            break;
        default:
            task.status_ = TaskStatus::kUnsupportedOperation;
            return;
    }

    if (res.error_ != lit::ErrorStatus::kOk)
    {
        task.status_ = TaskStatus::kMathError;
        return;
    }
    task.result_ = res.value_;
}

void printResult(const Task& task)
{
    printf("%d\n", task.result_);
}

void handleTaskStatus(TaskStatus status)
{
    switch (status)
    {
        case TaskStatus::kOk:
            break;
        case TaskStatus::kMathError:
            printf("Calculation failed\n");
            exit(EXIT_FAILURE);
        case TaskStatus::kHelp:
            printf("Usage: calc --first(-f) <number> --second(-s) "
                   "<number> --operation(-o) <one of: add, sub, mul, "
                   "div, pow, fact(requires only --first)>\n");
            exit(EXIT_SUCCESS);
        case TaskStatus::kInvalidLaunch:
            fprintf(stderr, "calc: Use --help for more information.\n");
            exit(EXIT_FAILURE);
        case TaskStatus::kInvalidNumber:
            fprintf(stderr,
                    "Invalid number. Use --help for more information.\n");
            exit(EXIT_FAILURE);
        case TaskStatus::kUnsupportedOperation:
            fprintf(
                stderr,
                "Unsupported operation. Use --help for more information.\n");
            exit(EXIT_FAILURE);
    }
}

} // namespace

int main(int argc, char** argv)
{
    applicationRun(argc, argv);
}
