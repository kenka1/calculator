# calculator

Simple C++ cli-calculator for integeres

## Features

- add
- subtract
- multiply
- divide
- pow
- factorial

## Requirements

- CMake 3.15+
- Ninja
- Clang 21
- GCC/Clang compiler

## Install
```bash
cd calculator
cmake -B build
sudo cmake --build build --target install
```

## Help
```bash
calc --help
```


## Build

```bash
cd calculator
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DUSE_CLANG_FORMAT=ON -DUSE_CLANG_TIDY=ON
cmake --build build
```

## Run tests
```bash
./test/test.sh ./build/bin/calc
```
