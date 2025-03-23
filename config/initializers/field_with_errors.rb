# config/initializers/field_with_errors.rb
ActionView::Base.field_error_proc = Proc.new do |html_tag, _instance|
  html_tag.html_safe
end
