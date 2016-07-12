# sq.rb

rval = ("A".."I").to_a
cval = (1..9).to_a
sq=[]


3.times do
  # copy first 3 rval element to r
  r = rval.take(3)
  # copy first 3 element of cval to c
  3.times do
    # reset t array
    t = []
    c = cval.take (3)
    r.each do |x|
      c.each do |y|
        t << "#{x}#{y}"
      end
    end # should end up with 9 elements in t

    # push t into sq
    sq <<t
    # rotate cval
    cval.rotate!(3)
    # start again with same r values
  end

  #rotate rval
  rval.rotate!(3)
  # start again
end




sq.each {|a| p a}
