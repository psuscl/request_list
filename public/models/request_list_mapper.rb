class RequestListMapper

  attr_reader :opts

  def initialize(profile, opts)
    @profile = profile
    @opts = opts
  end

  def map
    raise NotImplementedError.new("Subclass must implement this")
  end

end
