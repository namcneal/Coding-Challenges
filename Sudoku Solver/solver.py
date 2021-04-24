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
        Add entry to the sudoku board
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
            False if entry is invalud or results in an invalid board configuration
        """
        if entry < 1 or entry > 9:
            return False

        # FIXME: add functionality below
        # check if number already in column

        # check if number already in row

        # check if number already in 3 x 3 square

        return True

    def readBoard(filename):
        # FIXME: add functionality to read board from text file
        return True

class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        """
        Do not return anything, modify board in-place instead.
        """

