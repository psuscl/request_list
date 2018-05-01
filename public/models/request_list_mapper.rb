class RequestListMapper

  def initialize(profile, opts)
    @profile = profile
    @opts = opts
  end

  def map
    raise NotImplementedError.new("Subclass must implement this")
  end

end
