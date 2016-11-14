class GameController < ApplicationController

  def start_new_game
    @grid = generate_grid(9)
    @start_time = Time.now

    render 'display_grid'
  end

  def display_score
    attempt = params[:attempt]
    start_time = params[:start_time]
    #run_game
    grid = params[:grid].split("")
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    # raise
    @score = run_game(attempt, grid, start_time, end_time)

    render 'display_score'
  end

  private

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    my_translation = translation(attempt)
    if !in_grid?(attempt, grid)
      { time: end_time - start_time, translation: nil, score: 0, message: "not in the grid" }
    elsif my_translation == "unknown_word"
      { time: end_time - start_time, translation: nil, score: 0, message: "not an english word" }
    else
      score = attempt.length / (end_time - start_time) * 1000
      { time: end_time - start_time, translation: my_translation, score: score, message: "well done" }
    end
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times { grid << ("A".."Z").to_a.sample }
    return grid
  end

  def in_grid?(attempt, grid)
    local_grid = grid.join
    result = true
    attempt.upcase.chars.each do |letter|
      local_grid.chars.include?(letter) ? local_grid = local_grid.sub(letter, "") : result = false
    end
    return result
  end

  def translation(attempt)
    my_key = "c9c62514-3027-4960-8c9c-6e0177ce433c"
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{my_key}&input=" + attempt
    my_h = JSON.parse(open(url).read)
    my_translation = my_h["outputs"][0]["output"]
    result = my_translation
    my_translation != attempt ? "" : result = "unknown_word"
    return result
  end
end
