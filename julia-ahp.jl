@time begin
    function sum_comparison_matrix_rows(comparison_matrix, number_of_criteria)
        sum_matrix_columns = zeros(Float64, 1, number_of_criteria)

        for row in comparison_matrix
            for (index, item) in enumerate(row)
                sum_matrix_columns[index] = sum_matrix_columns[index] + item
            end
        end

        return sum_matrix_columns
    end

    function build_normalized_matrix(sum_matrix_columns, number_of_criteria)
        normalized_matrix = []

        for row_number in 1:number_of_criteria
            normalized_row = []

            for column_number in 1:number_of_criteria
                normalized = comparison_matrix[row_number][column_number] / sum_matrix_columns[column_number]
                push!(normalized_row, normalized)
            end
            
            push!(normalized_matrix, normalized_row)
        end
        
        return normalized_matrix
    end

    function calculate_priority_vector(normalized_matrix, number_of_criteria)
        priority_vector = []

        for row in normalized_matrix
            push!(priority_vector, sum(row) / number_of_criteria)
        end

        return priority_vector
    end

    function calculate_largest_eigen_value(number_of_criteria, priority_vector, sum_matrix_columns)
        multiplied = []

        for i in 1:(number_of_criteria)
            push!(multiplied, priority_vector[i] * sum_matrix_columns[i])
        end
        
        return sum(multiplied)
    end

    function calculate_consistency_index(largest_eigen_value, number_of_criteria)
        return (largest_eigen_value - number_of_criteria) / (number_of_criteria - 1)
    end

    function calculate_consistency_ratio(consistency_index, number_of_criteria)
        random_index = Dict(
            1 => 0.00,
            2 => 0.00,
            3 => 0.58,
            4 => 0.90,
            5 => 1.12,
            6 => 1.24,
            7 => 1.32,
            8 => 1.41,
            9 => 1.45
        )
        
        return consistency_index / random_index[number_of_criteria]
    end

    function ahp(comparison_matrix)
        number_of_criteria = length(comparison_matrix[1])

        sum_matrix_columns = sum_comparison_matrix_rows(comparison_matrix, number_of_criteria)
        normalized_matrix = build_normalized_matrix(sum_matrix_columns, number_of_criteria)
        priority_vector = calculate_priority_vector(normalized_matrix, number_of_criteria)
        largest_eigen_value = calculate_largest_eigen_value(number_of_criteria, priority_vector, sum_matrix_columns)
        consistency_index = calculate_consistency_index(largest_eigen_value, number_of_criteria)
        consistency_ratio = calculate_consistency_ratio(consistency_index, number_of_criteria)

        return Dict("priority_vector" => priority_vector, "consistency_ratio" => consistency_ratio)
    end

    comparison_matrix = [
        [1, 3, 7, 9],
        [1/3, 1, 5, 7],
        [1/7, 1/5, 1, 3],
        [1/9, 1/7, 1/3, 1]
    ]

    result = ahp(comparison_matrix)
end
