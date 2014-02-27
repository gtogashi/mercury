class Page < ActiveRecord::Base
  self.table_name = :mercury_pages
  serialize :contents, Hash
end
