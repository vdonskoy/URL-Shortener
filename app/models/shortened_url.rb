require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :presence => true
  validates :short_url, :presence => true, :uniqueness => true
  validates :submitter_id, :presence => true

  belongs_to(
    :submitter,
    :class_name => "User",
    :foreign_key => :submitter_id,
    :primary_key => :id
  )

  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :shortened_url_id,
    :primary_key => :id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    :through => :visits,
    :source => :user
  )

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!( long_url: long_url,
                          short_url: ShortenedUrl.random_code,
                          submitter_id: user.id )
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("created_at > ?", 10.minutes.ago).count
  end

end


