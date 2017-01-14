require 'suture'
require 'byebug'

class Calculator
  def add(left, right)
    right.times do
      left += 1
    end
    left
  end
end

class Controller
  attr_accessor :params
  def initialize(left, right)
    @params = {left: left, right: right}
  end

  def show
debugger
    calc = Calculator.new
    @result = Suture.create :add,
      old: calc.method(:add),
      args: [
        params[:left],
        params[:right]
      ],
      record_calls: true
  end
end

Controller.new(1, 2).show
