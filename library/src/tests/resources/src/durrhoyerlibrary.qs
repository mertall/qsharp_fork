// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
namespace Test {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Core;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.DurrHoyerLibrary;

    // Function to find the maximum element in an array
    function MaxIntArray(arr : Int[]) : Int {
        mutable max = arr[0];
        for i in arr[1..Length(arr) - 1] {
            if (arr[i] > max) {
                set max = arr[i];
            }
        }
        return max;
    }

    // Function to compute the probability of finding the minimum index
    operation RunDurrHoyerMinimumUnitTestWithShots(shots : Int) : Unit {
        // Define test lists for the unit test
        let testLists = [
            [5, 3, 1, 2, 4],
            [6, 5, 4, 3, 1],
            [7, 5, 6, 1, 2]
        ];

        // Expected results (minimum element index for each list)
        let expectedMinIndices = [2, 4, 3];

        // Iterate over test cases
        for (list, expectedMinIndex) in Zipped(testLists, expectedMinIndices) {
            let maxValue = MaxIntArray(list);
            let double : Double = IntAsDouble(maxValue + 1);
            let log : Double = Log(double) / Log(2.0);
            let nQubits = Ceiling(log);

            // Variable to track how many times we find the correct minimum index
            mutable correctCount = 0;

            // Run the Durr-Hoyer algorithm multiple times (shots)
            for _ in 1..shots {
                let minIndex : Int = DurrHoyerAlgorithm(list, nQubits, "min");

                // Check if the found index matches the expected minimum index
                if (minIndex == expectedMinIndex) {
                    set correctCount += 1;
                }
            }

            // Calculate the probability of finding the correct minimum
            let probability = IntAsDouble(correctCount) / IntAsDouble(shots);

            // Assert that the probability is above 50%
            Assert(probability > 0.5, $"Probability of finding the minimum for list {list} is less than 50%. Found: {probability * 100.0}%");

            // Optionally print debugging info
            Message($"List: {list}");
            Message($"Probability of finding the minimum is {probability * 100.0}%");
        }
    }
    // Function to compute the probability of finding the maximum index
    operation RunDurrHoyerMaximumUnitTestWithShots(shots : Int) : Unit {
        // Define test lists for the unit test
        let testLists : Int[][]= [
            [5, 3, 1, 2, 4],
            [6, 5, 4, 3, 1],
            [7, 5, 6, 1, 2]
        ];

        // Expected results (maximum element index for each list)
        let expectedMinIndices : Int[] = [2, 4, 3];

        // Iterate over test cases
        for (list, expectedMinIndex) in Zipped(testLists, expectedMinIndices) {
            let maxValue = MaxIntArray(list);
            let double : Double = IntAsDouble(maxValue + 1);
            let log : Double = Log(double) / Log(2.0);
            let nQubits = Ceiling(log);

            // Variable to track how many times we find the correct maximum index
            mutable correctCount = 0;

            // Run the Durr-Hoyer algorithm multiple times (shots)
            for _ in 1..shots {
                let minIndex : Int = DurrHoyerFinding(list, nQubits, "min");

                // Check if the found index matches the expected maximum index
                if (minIndex == expectedMinIndex) {
                    set correctCount += 1;
                }
            }

            // Calculate the probability of finding the correct maximum
            let probability = IntAsDouble(correctCount) / IntAsDouble(shots);

            // Assert that the probability is above 50%
            Fact(probability >= 0.5, $"Probability of finding the maximum for list {list} is less than 50%. Found: {probability * 100.0}%");

            // Optionally print debugging info
            Message($"List: {list}");
            Message($"Probability of finding the maximum is {probability * 100.0}%");
        }
    }
}
