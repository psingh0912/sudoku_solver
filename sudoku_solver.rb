# sudoku_solver.rb

require 'pry'

class Grid

  attr_accessor :g, :sq

  def initialize
    @VAL = (1..9).to_a
    @ROW = ("A".."I").to_a
    @COL = (1..9).to_a
    @sq = make_sq_list
    @g = init_grid
    @iterations = 0
  end

  def show(reason, iteration)
    top_row = 0x2554.chr('UTF-8') + "#{0x2550.chr('UTF-8')}" * 35 + 0x2557.chr('UTF-8')
    mid_row = 0x2560.chr('UTF-8') + "#{0x2550.chr('UTF-8')}" * 11 + "#{0x256C.chr('UTF-8')}" + "#{0x2550.chr('UTF-8')}" * 11 + "#{0x256C.chr('UTF-8')}" + "#{0x2550.chr('UTF-8')}" * 11 +  "#{0x2563.chr('UTF-8')}"
    bottom_row = 0x255A.chr('UTF-8') + "#{0x2550.chr('UTF-8')}" * 35 + 0x255D.chr('UTF-8')
    r = ("A".."I").to_a
    c = (1..9).to_a
    v = []
    puts top_row

    3.times do
      v = r.shift(3)
      v.each do |x|
        row = []
        c.each do |y|
          row << eval_node(@g["#{x}#{y}"])
        end
        puts display_row(row)
      end
      puts mid_row
    end
    puts "  #{reason}! Iterations: #{iteration}"
    puts bottom_row
  end

  def display_row(arr)
    t=[]
    t << 0x2551.chr('UTF-8')
    3.times do
      t << arr.shift(3)
      t << 0x2551.chr('UTF-8')
    end
    t.join ("  ")
  end

  def eval_node(n)
    if n.size > 1; "."; else n[0]; end
  end

  def chk_sq(n)
    # Identify square. Make hash 's' of all nodes in the row whose value size is 1
    s={}
    a = @sq.select {|x| x.include? n}
    a[0].each {|i| s[i] = @g[i] if @g[i].size == 1}
    s.delete(n)

    presence_check(s,n)
  end

  def chk_cross(n)
    h = {}
    2.times do |x|
      tmp = @g.select {|k,v| k.split("")[x] == n.split("")[x] && v.size == 1}
      tmp.each {|k,v| h[k] = v}
    end
    h.delete(n)

    presence_check(h,n)
  end

  def presence_check(h,n)
    # cycle through each value in 's'. delete the element in node value array if it equals 's' value
    h.each {|k,v| @g[n].delete(v[0])}
  end

  def cycle
    @g.each do |k,v|
      if v.size > 1
        chk_cross(k)
        chk_sq(k)
      end
    end
  end

  def make_sq_list
    rval = @ROW
    cval = @COL
    sq=[]

    3.times do
      r = rval.take(3)
      3.times do
        t = []
        c = cval.take (3)
        r.each do |x|
          c.each do |y|
            t << "#{x}#{y}"
          end
        end
        sq <<t
        cval.rotate!(3)
      end
      rval.rotate!(3)
    end
    sq
  end

  def init_grid
    v = @ROW
    h = @COL
    g={}

    v.each do |x|
      h.each do |y|
        g["#{x}#{y}"] = (1..9).to_a
      end
    end
    g
  end

end

def make_puzzle
  h ={}
  f = File.open('game1.txt', 'r')
  f.each_line do |l|
    a = l.chomp.split('=')
    h[a[0]] = [a[1].to_i]
  end
  h
end

def solve(g)
  iteration = 0
  h = {}

  while true do
      grid_check={}
      # start cycle
      g.cycle
      # increment iteration
      iteration +=1
      # if all values of g.g are of length 0, puzzle is solved. Exit loop and show grid with number of iterations taken
      g.g.each {|k,v| grid_check[k] = v if v.size > 1 }
      #binding.pry
      if grid_check.size == 0
        reason = "Puzzle solved"
        g.show(reason, iteration)
        break
        # else if h = g, no changes have been made in the cycle and stalemate has been reached.
        # Exit loop and show grid with number of iterations and reason for exit (stalemate).
      elsif h == g.g
        reason = "Stalemate"
        g.show(reason, iteration)
        grid_check.each {|k,v| puts "#{k} : #{v}"}
        break
      end
      h = Marshal::load(Marshal.dump(g.g))
    end
    # Also show values og g.g elements where size > 1



  end


  g = Grid.new
  h = make_puzzle
  h.each {|k,v| g.g[k] = v}

  solve(g)





  binding.pry
