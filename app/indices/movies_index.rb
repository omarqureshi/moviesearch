if defined?(ThinkingSphinx)
  ThinkingSphinx::Index.define :movie, :with => :active_record, :delta => true do
    indexes title, plot, year
  end
end
