include("Board.jl")

function zero()
	return convert(UInt8, 0)
end

function backtrack(board::Array{UInt8, 2}, head::Int64, unfixed_entries::Vector{Int64})
	# Return the board if we have reached a solution
	if isboard_solved(board) 
		return board
	end

	# Convert the current head for the unfixed_entries into an entry label and 
	# grab the value of the entry
	current_label = unfixed_entries[head]
	current_value = getentry(board, current_label)

	# Try to increment the value of the current entry under consideration
	new_board  = setentry(board, current_label, current_value + 1)

	# If the move is valid, keep it optimistically and move onto the next entry
	if isboard_valid(new_board)
		backtrack(new_board, head+1, unfixed_entries)
	end


	# If the move produces an invalid board, there are two choices:

	# 1) If the entry's current value was a 9, then the we can't increment it anymore
	#    so set it equal to zero and try again on the previous entry

	# TODO: Somehow if you call this before testing the new board, then you get an error.
	#       I have no idea how. So I need to find out.
	if current_value == 9
		zero_current = setentry(board, current_label, zero())
		backtrack(zero_current, head-1, unfixed_entries)
	end

	# 2) If the entry's current value was alright, but the move still violated the rules
	#    of Sudoku, then try again on the same entry, incrementing it on the next call
	backtrack(new_board, head, unfixed_entries)
end


# Load the test board and its solution
test_board        = readboard("test_board.txt")
verified_solution = readboard("test_correct_output.txt")

# Determine which entries are available to change
unfixed_entries = enum_empty_entries(test_board)

# Try and find a solution
@time solution = backtrack(test_board, 1, unfixed_entries)

if solution == verified_solution
	print("\nCongratulations, you've solved it.\n")
end
