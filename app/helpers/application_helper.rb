# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #Loading indicator for AJAX actions
  def loader id, text
    "<span id='#{id}' class='loader' style='display:none;'>#{text}</span>"
  end

  # return array of available marker icons
  def markers
    dir = [Rails.root, 'public','images','markers'].join('/')
    fullpaths = Dir[dir + '/*.png'] + Dir[dir + '/alphabet/*.png'] + Dir[dir + '/custom/*.png']
    escaped_dir = dir.gsub('/','\/')
    partial_paths = fullpaths.map{ |p| p.gsub(/#{escaped_dir}\/(.*).png/,'\1') }
    partial_paths.select {|p| !p.match('shadow')}
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, 'x'.html_safe, class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

end
