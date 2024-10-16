module ApplicationHelper
  def flash_class_for(flash_type)
    case flash_type.to_sym
    when :notice
      "flash-success"
    when :alert
      "flash-error"
    else
      "flash-info"
    end
  end
end
