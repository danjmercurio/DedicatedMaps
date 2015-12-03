# Methods added to this helper will be available to all templates in the application.
module MarkersHelper

  # #Loading indicator for AJAX actions
  # def loader id, text
  #   "<span id='#{id}' class='loader' style='display:none;'>#{text}</span>"
  # end

  # # return array of available marker icons
  # def markers
  #   dir = [Rails.root, 'public','images','markers'].join('/')
  #   fullpaths = Dir[dir + '/*.png'] + Dir[dir + '/alphabet/*.png'] + Dir[dir + '/custom/*.png']
  #   escaped_dir = dir.gsub('/','\/')
  #   partial_paths = fullpaths.map{ |p| p.gsub(/#{escaped_dir}\/(.*).png/,'\1') }
  #   partial_paths.select {|p| !p.match('shadow')}
  # end

end
