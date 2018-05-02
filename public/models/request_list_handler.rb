class RequestListHandler

  attr_reader :name, :profile, :url

  def initialize(name, profile, url, list_mapper, item_mappers)
    @name = name
    @profile = profile
    @url = url
    @list_mapper = list_mapper
    @item_mappers = item_mappers
    @items = []
    @unhandled_items = []
  end


  def add(item)
    @items.push(item)
  end


  def list_map
    @list_mapper.map    
  end


  def each_item_map
    @items.each do |item|
      mapper = item_mapper_for(item)
      if mapper
        yield [item, mapper.map(item)]
      else
        Rails.logger.debug("RequestListHandler: No handler for #{item}")
        @unhandled_items.push(item)
      end
    end
    @unhandled_items
  end


  def item_mapper_for(item)
    @item_mappers[item.class]
  end

end
