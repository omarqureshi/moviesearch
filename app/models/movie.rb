class Movie < ActiveRecord::Base
  PER_PAGE = 50

  if defined?(Tire)
    include Tire::Model::Search
    include Tire::Model::Callbacks
    
    mapping do
      indexes :id,                          :type => "integer", :index => :not_analyzed
      indexes :presentation_title,          :type => "multi_field", :fields => {
        :analyzed => {:type => "string", :analyzer => "snowball", :boost => 10},
        :presentation_title => {:type => "string", :index => :not_analyzed}
      }
      indexes :plot,                        :analyzer => "snowball"
      indexes :year,                        :type => "integer"
    end

    def self.search(q, options={:page => 1})
      tire.search(:page => options[:page], :per_page => PER_PAGE) do
        query { string q, :default_operator => "AND" } if q.present?
        if options[:year]
          filter :term, :year => options[:year]
        end
        facet "years", :global => true do
          # current work around for getting all the years, not an
          # ideal fix, but, is one presented by
          # https://github.com/karmi/tire/issues/398
          terms :year, :size => 1000, :order => 'reverse_term'
        end
        sort { by :presentation_title } unless q.present?
      end
    end

    def to_indexed_json
      to_json(:methods => [:presentation_title])
    end

  end

  def presentation_title
    out = title
    out += (" - " + episode) if episode.present?
    out += (" ("+year.to_s+")") if year.present?
    out
  end

end
