"""
	gen_enumerated
	-------------
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
function gen_enumerated()
	board = zeros(UInt8, (9,9))

	count = 1
	for i = 1:9, j = 1:9
		board[i, j] = count
		count += 1
	end

	return board
end

"""
	entry_label2coord
	-------------
	Convert the enumeration label of an entry into a tuple giving its position 

	Parameters
	----------
	label = The enumeration label for the entry ∈ [1,81] 

	Returns
	-------
	The coordinates of the entry on the board ∈ [1,9] x [1,9] 
"""
function entry_label2coord(label::Int64)::Tuple{Int64, Int64}
	entry_row = (label-1) ÷ 9 + 1
	entry_col = (label-1) % 9 + 1

	return (entry_row, entry_col)
end

"""
	subsquare_label2coord
	-------------
	Convert the enumeration label for one of the 9 subsquares into a coordinate. 
	Like entries, the enumeration goes from left → right, top → bottom.

	Parameters
	----------
	label = The enumeration label for the entry ∈ [1,9] 

	Returns
	-------
	The coordinates of the subsquare on the board ∈ [1,3] x [1,93 
"""
function square_label2coord(label::Int64)::Tuple{Int64, Int64}
	square_row = (label-1) ÷ 3 + 1
	square_col = (label-1) % 3 + 1

	return (square_row, square_col)
end



"""
	getsubsquare
	-------------
	Extract one of the 9 subsquares that make up the Sudoku board

	Parameters
	----------
	board                = The Sudoku board under consideration
	subsquare_coordinate = Coordinates of the desired subsquare.
				           Each entry must be between 1-3.

	Returns
	-------
	True if any of the entries occur more than once. 
	False if all are unique.  
"""
function getsubsquare(board::Array{UInt8, 2}, subsquare_coordinate::Tuple{Int64, Int64})
	subsquare_row = subsquare_coordinate[1]
	subsquare_col = subsquare_coordinate[2]
	board_rows    = 1 + 3*(subsquare_row-1) : 3 + 3*(subsquare_row-1)
	board_cols    = 1 + 3*(subsquare_col-1) : 3 + 3*(subsquare_col-1)


	return board[board_rows, board_cols]
end

function getsubsquare(board::Array{UInt8, 2}, subsquare_label::Int64)
	return getsubsquare(board, square_label2coord(subsquare_label))
end

function getentry(board::Array{UInt8, 2}, entry_coordinate::Tuple{Int64, Int64})
	entry_row = entry_coordinate[1]
	entry_col = entry_coordinate[2]

	return board[entry_row, entry_col]
end

function getentry(board::Array{UInt8, 2}, entry_label::Int64)
	return getentry(board, entry_label2coord(entry_label))
end

function enum_filled_entries(board::Array{UInt8, 2})
	filled_entry_labels = gen_enumerated()[board .> 0]
	filled_entry_labels = convert.(Int, filled_entry_labels)

	return  (sort ∘ vec ∘ permutedims)(filled_entry_labels)
end

function enum_empty_entries(board::Array{UInt8, 2})
	empty_entry_labels = gen_enumerated()[board .< 1]
	empty_entry_labels = convert.(Int, empty_entry_labels)

	return  (sort ∘ vec ∘ permutedims)(empty_entry_labels)
end

"""
	contains_duplicates
	-------------------
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
	isboard_valid
	-------------
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
		return false
	end

	# Loop over each row and each column and check for duplicates
	for i in 1:9
		col_entries = filter(x->x>0, board[:, i])		
		if contains_duplicates(col_entries) 
			return false
		end

		row_entries = filter(x->x>0, board[i, :])
		if contains_duplicates(row_entries)
			return false
		end

		subsquare_coords  = square_label2coord(i)
		subsquare         = getsubsquare(board, subsquare_coords)
		subsquare_entries = filter(x->x>0, vec(subsquare))

		if contains_duplicates(subsquare_entries)
			return false
		end
	end

	return true
end


"""
	isboard_solved
	--------------
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
	setentry
	--------
	Add entry to the Sudoku board
	Entry must be valid integer (1 - 9) and must not result in an invalid board configuration

	Parameters
	----------
	board        = The sudoku board under consideration
	coordinate   = The coordinate on the 9x9 board at which to add the entry
	entry        = Number to add to board

	Returns
	-------
	A modified board if the move produces a valid board. 
	Otherwise, the original board.
"""
function setentry(board::Array{UInt8, 2}, coordinate::Tuple{Int64, Int64}, entry::UInt8)::Array{UInt8, 2}
	# Make a copy of the board and change it
	newboard = board
	newboard[coordinate[1], coordinate[2]] = entry

	# Make the move if the board produced is valid
	if isboard_valid(newboard)
		return newboard

	end

	# Reject the move otherwise
	return board
end

function setentry(board::Array{UInt8, 2}, entry_label::Int64, entry::UInt8)
	return setentry(board, entry_label2coord(entry_label), entry)
end

function setentry(board::Array{UInt8, 2}, coordinate::Tuple{Int64, Int64}, entry::Int64)::Array{UInt8, 2}
	return setentry(board, coordinate, convert(UInt8, entry))
end

function setentry(board::Array{UInt8, 2}, entry_label::Int64, entry::Int64)::Array{UInt8, 2}
	return setentry(board, entry_label2coord(entry_label), entry)
end

function readboard(filename::String)
	board = zeros(UInt8, (9,9))

	row = 1
	for line in readlines(filename)

		col = 1
		for char in line
			board[row, col] = convert(UInt8, char) - 48
			col += 1
		end

		row += 1
	end

	return board
end

# test = gen_testboard()
# print(vec(test'))
# setentry(test, (1,1), 0)
# print(contains_duplicates(test))
# print(isboard_valid(test))
