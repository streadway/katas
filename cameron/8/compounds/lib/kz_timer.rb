class SimpleTimer
  def run &block
    start = Time.now
    yield
    puts "(executed in #{(Time.now - start).to_f} seconds)"
  end
end
