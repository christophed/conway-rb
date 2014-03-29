#!/usr/bin/env ruby

require 'pry'

class Conway
  LIVE_CELL = '*'
  DYING_CELL = 'D'

  DEAD_CELL = nil
  REVIVING_CELL = 'R'

  attr_accessor :cells, :rows, :cols

  class << self
    def dead?(cell)
      cell == DEAD_CELL || cell == REVIVING_CELL
    end

    def alive?(cell)
      !dead?(cell)
    end

    def dying?(cell)
      cell == DEAD_CELL || cell == DYING_CELL
    end

    def reviving?(cell)
      !dying?(cell)
    end
  end

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @cells = []

    (1..rows).each do |r|
      row = r-1
      cells[row] = []
    end
  end

  def print_board
    system('clear')
    apply_to_cells! do |row, col|
      print "\n" if col == 0
      print self.class.dead?(cells[row][col]) ? ' ' : LIVE_CELL
    end
  end

  def mark_dead(row, col)
    cells[row][col] = DYING_CELL
  end

  def mark_alive(row, col)
    cells[row][col] = REVIVING_CELL
  end

  def kill(row, col)
    cells[row][col] = DEAD_CELL
  end

  def revive(row, col)
    cells[row][col] = LIVE_CELL
  end

  def step
    print_board
    mark_change!
    change!
  end

  #Any live cell with fewer than two live neighbors dies, as if caused by under-population.
  #Any live cell with two or three live neighbors lives on to the next generation.
  #Any live cell with more than three live neighbors dies, as if by overcrowding.
  #Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
  def mark_change!
    apply_to_cells! do |row, col|
      neighbors = num_neighbors(row, col)
      cell = cells[row][col]

      if self.class.alive?(cell) && (neighbors < 2 || neighbors > 3)
        mark_dead(row, col)
      elsif self.class.dead?(cell) && neighbors == 3
        mark_alive(row, col)
      end
    end
  end

  def change!
    apply_to_cells! do |row, col|
      if self.class.reviving?(cells[row][col])
        revive(row, col)
      else
        kill(row, col)
      end
    end
  end

  def num_neighbors(row, col)
    left = col == 0 ? 0 : col - 1
    right = col == (cols - 1) ? col : col + 1
    top = row == 0 ? 0 : row - 1
    bottom = row == (rows - 1) ? row : row +1

    sum = 0

    (left..right).each do |c|
      (top..bottom).each do |r|
        cell = cells[r][c]
        sum +=1 if self.class.alive?(cell) && !(r == row && c == col)
      end
    end

    sum
  end

  def apply_to_cells! &blk
    (1..rows).each do |r|
      row = r-1

      (1..cols).each do |c|
        col = c-1

        blk.call(row, col)
      end
    end
  end
end
