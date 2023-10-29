#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <start_index> <end_index>"
    exit 1
fi

# Extract start and end indices from command line arguments
start_index=$1
end_index=$2

# Validate that start_index is less than or equal to end_index
if [ "$start_index" -gt "$end_index" ]; then
    echo "Error: start_index must be less than or equal to end_index"
    exit 1
fi

# Generate CSV content and save it to a file named inputFile
for ((i = start_index; i <= end_index; i++)); do
    echo "$i, $((RANDOM % 100))" >> inputFile
done

echo "CSV file generated successfully: inputFile"
