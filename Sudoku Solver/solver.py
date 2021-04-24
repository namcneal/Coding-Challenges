import numpy as np

class Board:
    def __init__(self):
        """
        Default constructor
        Instantiate class with "empty" board (all entries are zero)
        """
        # 9 x 9 numpy array to house board
        self.board = np.zeros(9, 9)

    def addEntry(entry, row, col):
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
    
    def getSubsquare(row, col):
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

        # split board into nine sub-squares, labeled left-right, top-bottom (squares 1, 2, and 3 on top row, squares 4, 5, and 6 on middle row, etc.)
        # FIXME: need to come up with a nice way to do this
        # this function is under construction

        return 0



    def readBoard(filename):
        # FIXME: add functionality to read board from text file
        return True

class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        """
        Do not return anything, modify board in-place instead.
        """

