# `Philosophers Tester`

## Project Description

`philo_tester.sh` is a script designed to automate testing for the **Philosophers** project from **42 School**, which simulates the classic problem of philosophers, also known as the **Dining Philosophers Problem**. This script covers a wide range of scenarios to test for **deadlocks**, **data races**, **memory leaks**, **scenarios where a philosopher must die**, **scenarios where no philosopher should die**, and **death message timing**.

The script allows users to run all tests at once or focus on specific tests as needed.

## Features

- **Deadlock Tests**: Verifies if the program freezes or behaves inconsistently.
- **Data Race Tests**: Identifies race conditions using tools like Valgrind and DRD.
- **Memory Leak Detection**: Uses Valgrind to identify memory allocation issues.
- **Scenarios Where No Philosopher Should Die**: Validates proper behavior in safe scenarios.
- **Scenarios Where a Philosopher Must Die**: Checks if the program correctly identifies and reports a philosopher's death.
- **Death Message Timing Validation**: Ensures that messages are displayed within the correct timeframe (up to 10ms after the philosopher's death).

## Prerequisites

1. **Project Executable**: The script requires the `philo` executable to be in the same directory.
2. **Analysis Tools**: The following tools must be installed on the system:
   - **Valgrind**

Ensure that the `philo` executable is correctly compiled before starting the tests.

## Usage

Before running the script, ensure it has execution permissions. Use the following commands in the terminal:

```bash
chmod +x philo_tester.sh
bash philo_tester.sh [option] [parameters]
```

### Available Options

| Option         | Description                                                                                  |
|----------------|----------------------------------------------------------------------------------------------|
| `-d`           | Tests for **data races** and **deadlocks**.                                                  |
| `-l`           | Checks for **memory leaks**.                                                                 |
| `-s`           | Validates scenarios where **a philosopher must die**.                                        |
| `-c time`      | Tests scenarios where **no philosopher should die**, accepting the maximum execution time as a parameter. |
| `-t`           | Checks the **death message timing**.                                                         |
| `-a`           | Runs **all available tests**.                                                                |

### Usage Examples

1. Run all scenarios:
   ```bash
   bash philo_tester.sh -a
   ```

2. Test for deadlocks and data races:
   ```bash
   bash philo_tester.sh -d
   ```

3. Test scenarios where no philosopher should die for 60 seconds:
   ```bash
   bash philo_tester.sh -c 60
   ```

4. Check for memory leaks:
   ```bash
   bash philo_tester.sh -l
   ```

## Results and Logs

Test results are displayed in the terminal and temporarily stored in log files during execution. These files are automatically deleted at the end of the script.

### Result Interpretation

- **✅ No issues detected**: The program passed the test successfully.
- **❌ Problem detected**: Indicates a test failure.

## Contributions

Contributions to improve this script are welcome! Please submit **pull requests** or open **issues** on the official repository:

[Philosophers Tester on GitHub](https://github.com/AntonioSebastiaoPedro/philosophers_tester)

---

**Author:** Antonio Sebastião Pedro <br>
**42 Username:** ansebast <br>
**Email:** antoniosebastiaopedro19@outlook.com

🚀 **Happy Testing!**