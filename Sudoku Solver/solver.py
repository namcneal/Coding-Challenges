import numpy as np

class Board:
    def __init__(self):
        """
        Default constructor
        Instantiate class with "empty" board (all entries are zero)
        """
        # 9 x 9 numpy array to house board
        self.board = np.zeros((9, 9), dtype=np.int64)

    def addEntry(self, entry, row, col):
        """
        Add entry to the Sudoku board
        Entry must be valid integer (1 - 9) and must not result in an invalid board configuration

        Parameters
        ----------
        entry, row, col : integer
            entry = number to add to board
            row = row of proposed entry
            col = column of proposed entry

        Returns
        -------
        bool
            True if entry is valid and results in a valid board 
            False if entry is invalid or results in an invalid board configuration
        """
        # check if number is invalid
        if entry < 1 or entry > 9:
            return False

        # check if number already in column
        if entry in self.board[col]:
            return False 

        # check if number already in row
        if entry in self.board[row]:
            return False

        # check if number already in 3 x 3 square
        if entry in getSubsquare(row, col):
            return False

        # proposed entry is valid
        return True
    
    def getSubsquare(self, row, col):
        """
        Return the 3 x 3 sub-square in which the entry specified by row and column lives

        Parameters
        ----------
        row, col: integer
            row = row in board
            col = col in board

        Returns
        -------
        subsquare : 3 x 3 numpy array (integers)
            numpy array containing the entries in the sub-square
        """

        # TODO: Test this a bit more formally. I ran some and they checked out. 

        # Imagining that the nine subsquares are arranged in a 3 x 3 grid
        subsquare_row = row // 3
        subsquare_col = col // 3

        # Return the correct slicing in terms of the 9 x 9 rows 
        return self.board[3*subsquare_row:3*(subsquare_row + 1),
                          3*subsquare_col:3*(subsquare_col + 1)]


    def readBoard(self, filename):
        # FIXME: add functionality to read board from text file
        return True

    def __str__(self):
        return self.board.__str__()

    def labelEntries(self):
        """
        Enumerate and label the entries going left to right, top to bottom:
            0 1  2 3 4 6 7  8
            9 10   ...     17
                    .              
                    .
                    .
              ...  etc  ...

        Parameters
        ----------
        None

        Modifies
        ----------
        self.board : Changes each entry based on the enumeration detailed above.
                     Note that most of these are illegal placements.

        Returns
        -------
        None
        """
        count = 0

        for i in range(9):
            for j in range(9):
                test_board.board[i,j] = count
                count += 1

# class Solution:
#     def solveSudoku(self, board: List[List[str]]) -> None:
#         """
#         Do not return anything, modify board in-place instead.
#         """

