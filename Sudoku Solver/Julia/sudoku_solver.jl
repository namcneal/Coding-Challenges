"""
	Enumerate and label the entries going left to right, top to bottom:
	    1 2 3 4 5 6 7 8 9
	    10     ...     18
	            .              
	            .
	            .
	      ...  etc  ...


	Parameters
	----------
	None

	
	Returns
	-------
	The particular, non-valid, board described above.
"""
function gen_testboard()
	board = zeros(UInt8, (9,9))

	count = 1
	for i = 1:9, j = 1:9
		board[i, j] = count
		count += 1
	end

	return board
end


"""
	Extract one of the 9 subsquares that make up the Sudoku board
	
	Parameters
	----------
	board              = The Sudoku board under consideration
	subsquare_position = Coordinates of the desired subsquare.
				         Each entry must be between 1-3.



	Returns
	-------
	True if any of the entries occur more than once. 
	False if all are unique.  
"""
function get_subsquare(board::Array{UInt8, 2}, subsquare_position::Tuple{Int64, Int64})
	subsquare_row = subsquare_position[1]
	subsquare_col = subsquare_position[2]
	board_rows    = 1 + 3*(subsquare_row-1) : 3 + 3*(subsquare_row-1)
	board_cols    = 1 + 3*(subsquare_col-1) : 3 + 3*(subsquare_col-1)


	return board[board_rows, board_cols]
end


"""
	Determines whether a given container of unsigned, 8-bit integers
	contains a duplicate entry
	
	Parameters
	----------
	container = The array under consideration

	Returns
	-------
	True if any of the entries occur more than once. 
	False if all are unique.  
"""
function contains_duplicates(container::Array{UInt8})::Bool
	all_entries = (sort∘vec)(container)

	if length(unique(all_entries)) == length(all_entries)
		return false
	end

	
	for i = 1:length(all_entries) - 1
		if all_entries[i + 1] == all_entries[i]
			return true
		end
	end

	return false
end



"""
	Determines whether a given board configuration follows the rules of Sudoku.
	
	Parameters
	----------
	board = The Sudoku board under consideration

	Returns
	-------
	True if the board follows the rules. False otherwise. 
"""
function isboard_valid(board::Array{UInt8, 2})::Bool
	# Make sure all the entries are in the correct range
	if !isempty(filter(x-> (x > 9), board))
		# return false
	end

	# Loop over each row and each column and check for duplicates
	for i in 1:9
		col_entries = filter(x->x>0, board[:, i])		
		if contains_duplicates(col_entries) 
			return false
		end

		row_entries = filter(x->x>0, board[:, i])
		if contains_duplicates(row_entries)
			return false
		end
	end

	# Loop over the subsquares, checking for duplicates
	for i = 1:3, j=1:3
		if (contains_duplicates∘get_subsquare)(board, (i,j))
			return false
		end
	end

	return true
end


"""
	Determines whether a given board configuration is a valid Sudoku solution
	
	Parameters
	----------
	board = The Sudoku board under consideration

	Returns
	-------
	True if the board is completed, false if it is invalid or contains empty entries. 
"""
function isboard_solved(board::Array{UInt8, 2})::Bool
	# Check for empty entries and a valid board
	if (convert(UInt8, 0) in board) || !isboard_valid(board)
		return false
	end

	# If a board has no empty spaces remaining and is valid, then all its entries are between 1-9
	# and it cannot have any duplicates in any column, row or subsquare. Hence, it's solved.
	return true
end


"""
	Add entry to the Sudoku board
	Entry must be valid integer (1 - 9) and must not result in an invalid board configuration

	Parameters
	----------
	board      = The sudoku board under consideration
	position   = The position on the 9x9 board in which to add 
	entry      = Number to add to board

	Returns
	-------
	A modified board if the move produces a valid board. 
	Otherwise, the original board.
"""
function addentry(board::Array{UInt8, 2}, position::Tuple{Int64, Int64}, entry::UInt8)::Array{UInt8, 2}
	# Make a copy of the board and change it
	newboard = board
	newboard[position[1], position[2]] = entry

	# Make the move if the board produced is valid
	if isboard_valid(newboard)
		return newboard

	end

	# Reject the move otherwise
	return board
end

function addentry(board::Array{UInt8, 2}, position::Tuple{Int64, Int64}, entry::Int64)::Array{UInt8, 2}
	return addentry(board, position, convert(UInt8, entry))
end


# test = gen_testboard()
# addentry(test, (1,1), 0)
# print(contains_duplicates(test))
# print(isboard_valid(test))
# print(isboard_solved(test))