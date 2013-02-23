namespace :csv do
  desc 'Import CSV (v3!)'
  task :import => :environment do
    require 'csv'
    require 'twitter'
    office = Office.find_or_create_by_abbreviation_and_title '', ''
    FasterCSV.foreach ENV['CSV'], :headers => true, :header_converters => :symbol do |row|
      politician = Politician.create!(
        :first_name => row[:first_name],
        :last_name  => row[:last_name],
        :office     => office,
        :party      => Party.find_or_create_by_display_name_and_name(row[:party], row[:party]),
        :state      => row[:state],
        :twitter_id => Twitter.users([row[:user_name]]).first.id,
        :user_name  => row[:user_name]
      )
      exit
    end
  end
end
