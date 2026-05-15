#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    printf "Usage: %s <calculator>\n" "$0"
    exit 1
fi
calc=$1

count=0
failed=0

#Test No arguments
output=$("$calc" 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: NoArguments: Passed"
else
    echo "Test #${count}: NoArguments: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Invalid first number
output=$("$calc" -f 10abc -s 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: InvalidFirstNumber: Passed"
else
    echo "Test #${count}: InvalidFirstNumber: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Invalid second number
output=$("$calc" -f 10 -s 10abc -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: InvalidSecondNumber: Passed"
else
    echo "Test #${count}: InvalidSecondNumber: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Unknown operation
output=$("$calc" -f 10 -s 10 -o good 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: UnknownOperation: Passed"
else
    echo "Test #${count}: UnknownOperation: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Repeated flag -f
output=$("$calc" -f 10 -f 11 -s 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: RepeatedFlagF: Passed"
else
    echo "Test #${count}: RepeatedFlagF: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Repeated flag -s
output=$("$calc" -f 10 -s 10 -s 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: RepeatedFlagS: Passed"
else
    echo "Test #${count}: RepeatedFlagS: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Repeated flag -o
output=$("$calc" -f 10 -s 10 -o add -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: RepeatedFlagO: Passed"
else
    echo "Test #${count}: RepeatedFlagO: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Missing flag -f
output=$("$calc" -s 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: MissingFlagF: Passed"
else
    echo "Test #${count}: MissingFlagF: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Missing flag -s
output=$("$calc" -f 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: MissingFlagS: Passed"
else
    echo "Test #${count}: MissingFlagS: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Missing flag -o
output=$("$calc" -f 10 -s 10 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: MissingFlagO: Passed"
else
    echo "Test #${count}: MissingFlagO: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test ExtraOperations 
output=$("$calc" -f 10 -s 10 -o add add add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: ExtraOperations: Passed"
else
    echo "Test #${count}: ExtraOperations: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test HelpSuccess 
output=$("$calc" -h 2>/dev/null)
status=$?
if [[ "$status" -eq 0 ]]; then
    echo "Test #${count}: HelpSuccess: Passed"
else
    echo "Test #${count}: HelpSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test FloatType -f 
output=$("$calc" -f 10.34 -s 10 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: FloatTypeF: Passed"
else
    echo "Test #${count}: FloatTypeF: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test FloatType -s
output=$("$calc" -f 10 -s 10.34 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: FloatTypeS: Passed"
else
    echo "Test #${count}: FloatTypeS: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Add Success
output=$("$calc" -f 10 -s 10 -o add 2>/dev/null)
status=$?
if [[ "$output" -eq 20 && "$status" -eq 0 ]]; then
    echo "Test #${count}: AddSuccess: Passed"
else
    echo "Test #${count}: AddSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Add Overflow 
output=$("$calc" -f 2147483647 -s 1 -o add 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: AddOverflow: Passed"
else
    echo "Test #${count}: AddOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Add Zero 
output=$("$calc" -f 0 -s 0 -o add 2>/dev/null)
status=$?
if [[ "$output" -eq 0 && "$status" -eq 0 ]]; then
    echo "Test #${count}: AddZero: Passed"
else
    echo "Test #${count}: AddZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Sub Success
output=$("$calc" -f 10 -s 10 -o sub 2>/dev/null)
status=$?
if [[ "$output" -eq 0 && "$status" -eq 0 ]]; then
    echo "Test #${count}: SubSuccess: Passed"
else
    echo "Test #${count}: SubSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Sub Overflow 
output=$("$calc" -f -2147483648 -s 1 -o sub 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: SubOverflow: Passed"
else
    echo "Test #${count}: SubOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Sub Zero
output=$("$calc" -f 0 -s 0 -o sub 2>/dev/null)
status=$?
if [[ "$output" -eq 0 && "$status" -eq 0 ]]; then
    echo "Test #${count}: SubZero: Passed"
else
    echo "Test #${count}: SubZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Mul Success 
output=$("$calc" -f 10 -s 10 -o mul 2>/dev/null)
status=$?
if [[ "$output" -eq 100 && "$status" -eq 0 ]]; then
    echo "Test #${count}: MulSuccess: Passed"
else
    echo "Test #${count}: MulSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Mul Overflow 
output=$("$calc" -f 2147483647 -s 2 -o mul 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: MulOverflow: Passed"
else
    echo "Test #${count}: MulOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Mul Zero 
output=$("$calc" -f 0 -s 0 -o mul 2>/dev/null)
status=$?
if [[ "$output" -eq 0 && "$status" -eq 0 ]]; then
    echo "Test #${count}: MulZero: Passed"
else
    echo "Test #${count}: MulZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Div Success 
output=$("$calc" -f 100 -s 10 -o div 2>/dev/null)
status=$?
if [[ "$output" -eq 10 && "$status" -eq 0 ]]; then
    echo "Test #${count}: DivSuccess: Passed"
else
    echo "Test #${count}: DivSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Div Overflow 
output=$("$calc" -f -2147483648 -s -1 -o div 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: DivOverflow: Passed"
else
    echo "Test #${count}: DivOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Div by zero
output=$("$calc" -f 100 -s 0 -o div 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: DivByZero: Passed"
else
    echo "Test #${count}: DivByZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Div zero
output=$("$calc" -f 0 -s 100 -o div 2>/dev/null)
status=$?
if [[ "$output" -eq 0 && "$status" -eq 0 ]]; then
    echo "Test #${count}: DivZero: Passed"
else
    echo "Test #${count}: DivZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Pow Success 
output=$("$calc" -f 2 -s 10 -o pow 2>/dev/null)
status=$?
if [[ "$output" -eq 1024 && "$status" -eq 0 ]]; then
    echo "Test #${count}: PowSuccess: Passed"
else
    echo "Test #${count}: PowSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Pow Overflow 
output=$("$calc" -f 100 -s 100 -o pow 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: PowOverflow: Passed"
else
    echo "Test #${count}: PowOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Pow by zero 
output=$("$calc" -f 100 -s 0 -o pow 2>/dev/null)
status=$?
if [[ "$output" -eq 1 && "$status" -eq 0 ]]; then
    echo "Test #${count}: PowByZero: Passed"
else
    echo "Test #${count}: PowByZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Pow ZeroZero 
output=$("$calc" -f 0 -s 0 -o pow 2>/dev/null)
status=$?
if [[ "$output" -eq 1 && "$status" -eq 0 ]]; then
    echo "Test #${count}: PowZeroZero: Passed"
else
    echo "Test #${count}: PowZeroZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Fact Success 
output=$("$calc" -f 8 -o fact 2>/dev/null)
status=$?
if [[ "$output" -eq 40320 && "$status" -eq 0 ]]; then
    echo "Test #${count}: FactSuccess: Passed"
else
    echo "Test #${count}: FactSuccess: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Fact zero 
output=$("$calc" -f 0 -o fact 2>/dev/null)
status=$?
if [[ "$output" -eq 1 && "$status" -eq 0 ]]; then
    echo "Test #${count}: FactZero: Passed"
else
    echo "Test #${count}: FactZero: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Fact one 
output=$("$calc" -f 1 -o fact 2>/dev/null)
status=$?
if [[ "$output" -eq 1 && "$status" -eq 0 ]]; then
    echo "Test #${count}: FactOne: Passed"
else
    echo "Test #${count}: FactOne: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Fact SecondArgument
output=$("$calc" -f 8 -s 5 -o fact 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: FactSecondArgument: Passed"
else
    echo "Test #${count}: FactSecondArgument: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

#Test Fact Overflow 
output=$("$calc" -f 20 -o fact 2>/dev/null)
status=$?
if [[ "$status" -ne 0 ]]; then
    echo "Test #${count}: FactOverflow: Passed"
else
    echo "Test #${count}: FactOverflow: Failed"
    failed=$((failed+1))
fi
count=$((count+1))

passed="$(awk -v a=${failed} -v b=${count} 'BEGIN{printf "%.0f", (b-a)/b*100.0}')"
printf "\n%s%% tests passed, %s failed out of %s.\n" "$passed" "$failed" "$count"
