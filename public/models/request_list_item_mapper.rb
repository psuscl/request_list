class RequestListItemMapper

  def initialize(profile, opts)
    @profile = profile
    @opts = opts
  end

  def map(item)
    raise NotImplementedError.new("Subclass must implement this")
  end

end
