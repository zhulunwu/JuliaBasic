using Base.Iterators: repeated
using Makie

r = 1:8
board = isodd.(r .+ r')
scene = Scene(resolution = (800, 800))
heatmap!(scene, board, scale_plot = false, show_axis = false)
white = ['♕', '♔', '♖', '♖', '♗', '♗', '♘', '♘', repeated('♙', 8)...]
wx_positions = [4, 5, 1, 8, 3, 6, 2, 7, (1:8)...]
wy_positions = [repeated(1, 8)..., repeated(2, 8)...]
w_positions = Point2.(wx_positions, wy_positions)
white_game = scatter!(
    scene, w_positions, marker = white,
    scale_plot = false, show_axis = false,
    markersize = 0.5, marker_offset = Vec2f0(-0.7)
)[end]
black = Char.(Int.(white) .+ 6)
b_positions = Point2f0.(wx_positions, [repeated(8, 8)..., repeated(7, 8)...])
black_game = scatter!(
    scene, b_positions, marker = black,
    scale_plot = false, show_axis = false,
    markersize = 0.5, marker_offset = Vec2f0(-0.7)
)[end]

function move_fig!(color, figure, target)
    game = color == :white ? white_game : black_game
    game[1][][figure] = target
    game[1][] = game[1][]
end

move_fig!(:white, 9, (1, 4))
