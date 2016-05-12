class Course < ActiveRecord::Base
  has_one :replacement, class_name: "Course", foreign_key: :predecessor_id
  belongs_to :predecessor, class_name: "Course"
end
