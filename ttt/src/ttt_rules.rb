require 'matrix'
require 'pry-byebug'
module TTTRules
    attr_reader :board

    def winner?
        winning_combos.any? { |combo| combo.uniq.length == 1 }
    end

    def winner
        winner? ? winning_combos.find { |combo| combo.uniq.length == 1}[0] : nil 
    end

    def tie?
        board.full? && !winner?
    end

    def over?
        winner? || tie?
    end

    private

    def winning_combos
        combos = []
        matrix = board_to_matrix
        combos << matrix.row_vectors.map { |v| v.to_a }
        combos << matrix.column_vectors.map { |v| v.to_a }
        combos << diagonals
        combos.flatten(1)
    end

    def board_to_matrix
        Matrix[*board.spaces.each_slice(board.row_size).to_a]
    end

    def get_diagonal(matrix)
        matrix.each(:diagonal).to_a
    end

    def rotate(matrix)
       get_diagonal(Matrix[*matrix.to_a.map(&:reverse).transpose])
    end

    def diagonals
        primary = get_diagonal(board_to_matrix)
        minor = rotate(board_to_matrix)
        [primary, minor]
    end
end
