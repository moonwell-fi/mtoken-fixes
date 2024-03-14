#!/bin/bash
# source .env

output_title() {
  local text="# $1"
  echo "$text" > MutationTestOutput/Result.md
}

output_heading() {
  local text="\n## $1"
  echo "$text" >> MutationTestOutput/Result.md
}

output_code_result() {
  local output="$1"
  local heading="$2"
  local content="<details>
<summary>$heading</summary>\n
\`\`\`\n$output\n\`\`\`
</details>"
  echo "$content" >> MutationTestOutput/Result.md
}

# Function to extract the last line from a file
get_last_line() {
  local file="$1"
  tail -n 1 "$file"
}

get_content_after_pattern() {
  local output="$1"
  local pattern="$2"

  line_number=$(grep -n "$pattern" "$output" | head -n 1 | cut -d ':' -f1)

  content_after_n_lines=$(tail -n +$((line_number)) "$output")

  clean_content=$(echo "$content_after_n_lines" | sed 's/\x1B\[[0-9;]*m//g')

  # Return the extracted content
  echo "$clean_content"
}


process_test_output() {
  local test_type="$1"
  local output="$2"

  echo "\n### $test_type:" >> MutationTestOutput/Result.md

  # Check if output contains "Failing tests: "
  if grep -q "Failing tests:" "$output"; then
    
    # Extract last line
    last_line=$(get_last_line "$output")

    # Remove escape sequences and color codes using sed
    clean_line=$(echo "$last_line" | sed 's/\x1B\[[0-9;]*m//g')

    # Extract failed and passed tests using awk
    failed_tests=$(echo "$clean_line" | awk '{print $5}')
    passed_tests=$(echo "$clean_line" | awk '{print $8}')

    # Mark current mutation as failed
    is_current_mutation_failed=1

    # Append to last_lines.txt with desired format
    echo "Failed $test_type: $failed_tests, Passed Tests: $passed_tests" >> MutationTestOutput/Result.md

    content_after_pattern=$(get_content_after_pattern "$output" "Failing tests:")
    output_code_result "$content_after_pattern" "View Failing tests"
  else
    # Extract last line
    last_line=$(get_last_line "$output")

    # Remove escape sequences and color codes using sed
    clean_line=$(echo "$last_line" | sed 's/\x1B\[[0-9;]*m//g')

    # Extract failed and passed tests using awk
    passed_tests=$(echo "$clean_line" | awk '{print $7}')

    # Append to last_lines.txt with desired format
    echo "Failed $test_type: 0, Passed Tests: $passed_tests" >> MutationTestOutput/Result.md
  fi
}

target_file="src/MErc20DelegateFixer.sol"
target_dir="MutationTestOutput"
num_files=2

# Create directory for output files if it doesn't exist
mkdir -p "$target_dir"

# Number of failed mutations
failed_mutation=0

is_current_mutation_failed=0 # Intialized as false

# Append Mutation Result to Result.md with desired format
output_title "Mutation Results\n"

# Loop through the number of files
for (( i=2; i <= num_files; i++ )); do
  # Construct dynamic file path using iterator
  file_path="gambit_out/mutants/$i/src/MErc20DelegateFixer.sol"

  # Check if file exists before copying
  if [[ -f "$file_path" ]]; then
    # Mark current mutation as not failed at the start of run
    (( is_current_mutation_failed=0 ))
    # Copy the file's contents to the target file
    cat "$file_path" > "$target_file"

    output_heading "Mutation $i"

    mutation_diff=$(gambit summary --mids $i)
    clean_mutation_diff=$(echo "$mutation_diff" | sed 's/\x1B\[[0-9;]*m//g')
    output_code_result "$clean_mutation_diff" "View mutation diff"

    temp_output_file="$target_dir/temp.txt"

    touch "$temp_output_file"

    # Run unit tests and capture output
    integration_test_output=$(forge test --match-contract MIPM17IntegrationTest --fork-url https://rpc.api.moonbeam.network -v)
    echo "$integration_test_output" > "$temp_output_file"

    # Process unit test outputs using the function
    process_test_output "Integration Tests" "$temp_output_file"

    output_heading "Certora Mutation Results: \n"

    solc-select use 0.5.17
    certora_run_output=$(certoraRun certora/confs/SharePrice.conf --wait_for_results)
    echo "$certora_run_output" > "$temp_output_file"

    # # Extract content after the pattern
    content_after_pattern=$(get_content_after_pattern "$temp_output_file" "Results for all:")
    
    output_code_result "$content_after_pattern" "View Result"

    rm "$temp_output_file"

    if [[ $is_current_mutation_failed -eq 1 ]]; then
      # Increament total mutation failed
      (( failed_mutation++ ))
    fi

  else
    echo "Warning: File '$file_path' not found."
  fi
  echo "\n==================\n" >> MutationTestOutput/Result.md
done

# Append to Result.md with desired format
echo "Failed Mutations: $failed_mutation" >> MutationTestOutput/Result.md