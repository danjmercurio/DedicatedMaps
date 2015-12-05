# to run: rake db:seed


# Staging Area Companies
# # IDs are important! Might want to change XML upload id to "acces_id" or something not autoincremented.
# StagingAreaCompany.delete_all
# conn = StagingAreaCompany.connection
# conn.execute("SELECT setval('staging_area_companies_id_seq', 1, false)") if conn.adapter_name == 'PostgreSQL'
# conn.execute('ALTER TABLE staging_area_companies AUTO_INCREMENT = 0') if conn.adapter_name == 'MySQL'
# conn.execute("delete from sqlite_sequence where name = 'staging_area_companies'") if conn.adapter_name == 'SQLite'
# StagingAreaCompany.create(:name => "crc", :title =>  "Clean Rivers Cooperative")               # :id => 1,
# StagingAreaCompany.create(:name => "mfsa",  :title=>  "Marine Fire & Safety Assoc.")           # :id => 2, 
# StagingAreaCompany.create(:name => "poi",   :title=>  "Points Of Interest")                     # :id => 3, 
# StagingAreaCompany.create(:name => "msrc",  :title=>  "MSRC - WRRL")                           # :id => 4, 
# StagingAreaCompany.create(:name => "nrc",   :title=>  "National Response Corporation")          # :id => 5, 
# StagingAreaCompany.create(:name => "bco",   :title=>  "Burrard Clean Operations")               # :id => 6, 
# StagingAreaCompany.create(:name => "cic",   :title=>  "Clean Islands Council")                  # :id => 7, 
# StagingAreaCompany.create(:name => "seapro",:title=> "Seapro")                              # :id => 8, 
# StagingAreaCompany.create(:name => "ccs",   :title=>"Clean Cowlitz Sweep")                    # :id => 9, 
# StagingAreaCompany.create(:name => "ies",   :title=>"IES")                                   # :id => 10, 
# StagingAreaCompany.create(:name => "tbl",   :title=>"Tidewater Barge Lines")                 # :id => 11, 
# StagingAreaCompany.create(:name => "gds",   :title=>"Global Diving & Salvage")               # :id => 12, 
# StagingAreaCompany.create(:name => "wrrl",  :title=> "Western Region Resource List")         # :id => 13, 
# StagingAreaCompany.create(:name => "nrc_wrrl", :title=> "NRC - WRRL")                       # :id => 14, 


# AisShipTypeIcon.create(:ship_type_code =>20, :icon_id => 9)
# AisShipTypeIcon.create(:ship_type_code =>21, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>22, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>23, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>24, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>25, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>26, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>27, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>28, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>29, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>30, :icon_id =>11)
# AisShipTypeIcon.create(:ship_type_code =>31, :icon_id =>10)
# AisShipTypeIcon.create(:ship_type_code =>32, :icon_id =>10)
# AisShipTypeIcon.create(:ship_type_code =>34, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>35, :icon_id =>12)
# AisShipTypeIcon.create(:ship_type_code =>36, :icon_id =>7)
# AisShipTypeIcon.create(:ship_type_code =>37, :icon_id =>7)
# AisShipTypeIcon.create(:ship_type_code =>38, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>39, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>40, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>41, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>42, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>43, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>44, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>45, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>46, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>47, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>48, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>49, :icon_id =>4)
# AisShipTypeIcon.create(:ship_type_code =>50, :icon_id =>6)
# AisShipTypeIcon.create(:ship_type_code =>51, :icon_id =>12)
# AisShipTypeIcon.create(:ship_type_code =>52, :icon_id =>5)
# AisShipTypeIcon.create(:ship_type_code =>53, :icon_id =>5)
# AisShipTypeIcon.create(:ship_type_code =>54, :icon_id =>8)
# AisShipTypeIcon.create(:ship_type_code =>55, :icon_id =>12)
# AisShipTypeIcon.create(:ship_type_code =>56, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>57, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>58, :icon_id =>12)
# AisShipTypeIcon.create(:ship_type_code =>59, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>60, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>61, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>62, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>63, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>64, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>65, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>66, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>67, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>68, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>69, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>70, :icon_id =>1)
# AisShipTypeIcon.create(:ship_type_code =>71, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>72, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>73, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>74, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>75, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>76, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>77, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>78, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>79, :icon_id =>2)
# AisShipTypeIcon.create(:ship_type_code =>80, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>81, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>82, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>83, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>84, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>85, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>86, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>87, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>88, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>89, :icon_id =>3)
# AisShipTypeIcon.create(:ship_type_code =>90, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>91, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>92, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>93, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>94, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>95, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>96, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>97, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>98, :icon_id =>9)
# AisShipTypeIcon.create(:ship_type_code =>99, :icon_id =>9)
# connection = ActiveRecord::Base.connection
# connection.tables.each do |table|
#     connection.execute("TRUNCATE #{table}") unless table == "schema_migrations"
# end
# sql = File.read('db/ddmaps.sql').mb_chars.tidy_bytes(force = true)
# connection.execute(sql)
puts 'Run in mysql client: source db/ddmaps.sql'