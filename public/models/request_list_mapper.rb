class RequestListMapper

  attr_reader :opts

  def initialize(profile, opts)
    @profile = profile
    @opts = opts
  end

  def form_fields
    # implement in subclass
    {}
  end

end
