class Odb < ActiveRecord::Base
  attr_accessible :site, :cdn, :file, :mesurement, :status
end
