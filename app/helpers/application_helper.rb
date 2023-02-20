module ApplicationHelper

  def full_title(page_name = "")
    base_name = "勤怠システム"
    if page_name.empty?
      base_name
    else
      page_name + " | " + base_name
    end
  end

end
