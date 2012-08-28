module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display:none"
    end
    content_tag("div", attributes, &block)
  end

  def usd_to_euros(price)
    price * if I18n.locale == :es then 0.7998
            else 1
            end
  end
end
